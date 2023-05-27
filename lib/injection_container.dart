import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notey/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:notey/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:notey/features/todo/domain/usecases/get_all_todos.dart';

import 'core/platform/network/network_info.dart';
import 'core/providers/hive_helper.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/add_todo.dart';
import 'features/todo/presentaion/cubit/todo_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
// App Features
  //BLOC

// Business Features
  // CUBIT
  sl.registerFactory(() => TodoCubit(addTodoUsecase: sl(), getAllTodosUsecase: sl()));

  // Use Case
  sl.registerLazySingleton(() => AddTodoUsecaseImpl(sl()));
  sl.registerLazySingleton(() => GetAllTodosUsecaseImpl(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(
          localDataSource: sl(),
          remoteDataSource: sl(),
          networkInfo: sl(),
    ),
  );

  // Datasource
  sl.registerLazySingleton<TodoRemoteDataSource>(
        () => TodoRemoteDataSourceImpl(
          dio: sl()
    ),
  );
  sl.registerLazySingleton<TodoLocalDataSource>(
        () => TodoLocalDataSourceImpl(
          hive: sl()
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Providers
  sl.registerLazySingleton(() => HiveHelper(hive: sl()));

  // External
  final Dio dio = Dio();
  final HiveInterface hive = Hive;
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => hive);
}