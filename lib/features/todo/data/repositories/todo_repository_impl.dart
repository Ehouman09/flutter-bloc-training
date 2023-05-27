import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network/network_info.dart';
import '../../../../core/util/app_constants.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_payload.dart';

class TodoRepositoryImpl extends TodoRepository{

  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure,  Map>> addTodo(TodoPayload todoPayload) async{
    if(await networkInfo.isConnected){
      try{
        final todo = await remoteDataSource.addTodo(todoPayload);
        return Right(todo);
      } on RequestException catch (error)  {
        return Left(ServerFailure(
          statusCode: error.statusCode!,
          message: error.message,
          response: error.response,
        ));
      }
    }else{
      return Left(
        ServerFailure(
          statusCode: -1,
          message: AppConstants.networkError,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async{
    if(await networkInfo.isConnected){
      try {
        final remoteTodos = await remoteDataSource.getAllTodos();
        localDataSource.cacheTodos(remoteTodos);
        return Right(remoteTodos);
      } on RequestException catch (error) {
        return Left(ServerFailure(
          statusCode: error.statusCode!,
          message: error.message,
          response: error.response,
        ));
      }
    }else{
      try {
        final todos = await localDataSource.getAllTodosFromLocal();
        return Right(todos);
      } on CacheException {
        return Left(CacheFailure(message: "No data cached..."));
      }
    }
  }
}