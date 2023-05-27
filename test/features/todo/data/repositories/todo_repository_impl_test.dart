import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notey/core/error/exceptions.dart';
import 'package:notey/core/error/failures.dart';
import 'package:notey/core/platform/network/network_info.dart';
import 'package:notey/core/util/app_constants.dart';
import 'package:notey/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:notey/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:notey/features/todo/data/models/todo_model.dart';
import 'package:notey/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:notey/features/todo/domain/entities/todo.dart';

import 'todo_repository_impl_test.mocks.dart';

@GenerateMocks([TodoLocalDataSource, TodoRemoteDataSource, NetworkInfo])
void main() {
  late TodoRepositoryImpl repository;
  late MockTodoRemoteDataSource mockRemoteDataSource;
  late MockTodoLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTodoRemoteDataSource();
    mockLocalDataSource = MockTodoLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TodoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final List<TodoModel> todoListRes = [
    TodoModel(id: "kzd", title: "Titre1", description: "Description1", color: "Red"),
    TodoModel(id: "ret", title: "Titre2", description: "Description2", color: "Blue")
  ];
  final List<Todo> todoList = todoListRes;

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }


  group('getAllTodos', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    /*test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getAllTodos();
      // assert
      verify(mockNetworkInfo.isConnected);
    });*/

    runTestsOnline((){
      test(
        'should return all list of todo models',
            () async {
          // arrange
          when(mockRemoteDataSource.getAllTodos())
              .thenAnswer((_) async => todoListRes);
          // act
          final result = await repository.getAllTodos();
          // assert
          verify(mockRemoteDataSource.getAllTodos());
          expect(result, equals(Right(todoList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getAllTodos())
              .thenAnswer((_) async => todoListRes);
          // act
          await repository.getAllTodos();
          // assert
          verify(mockRemoteDataSource.getAllTodos());
          verify(mockLocalDataSource.cacheTodos(todoListRes));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getAllTodos()).thenThrow(RequestException(statusCode: -1, message: AppConstants.networkError));
          // act
          final result = await repository.getAllTodos();
          // assert
          verify(mockRemoteDataSource.getAllTodos());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure(statusCode: -1,
            message: AppConstants.networkError,))));
        },
      );
    });

    runTestsOffline((){
      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getAllTodosFromLocal())
              .thenAnswer((_) async => todoListRes);
          // act
          final result = await repository.getAllTodos();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getAllTodosFromLocal());
          expect(result, equals(Right(todoList)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
            () async {
          // arrange
          when(mockLocalDataSource.getAllTodosFromLocal())
              .thenThrow(CacheException());
          // act
          final result = await repository.getAllTodos();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getAllTodosFromLocal());
          expect(result, equals(Left(CacheFailure(message: "No data cached..."))));
        },
      );
    });
  });

  group('addTodo', (){
    runTestsOffline((){

    });
  });
}