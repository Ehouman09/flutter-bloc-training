import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notey/core/error/failures.dart';
import 'package:notey/features/todo/data/models/todo_payload.dart';
import 'package:notey/features/todo/domain/repositories/todo_repository.dart';
import 'package:notey/features/todo/domain/usecases/add_todo.dart';

import 'add_todo_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late AddTodoUsecaseImpl usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = AddTodoUsecaseImpl(mockTodoRepository);
  });

  test('should get the added todo from the repository', () async {
    final todoPayload = TodoPayload(title: "test", description: "desc", color: "red");

    Right<Failure,  Map<String, dynamic>> todoResponse = Right<Failure,  Map<String, dynamic>>({});

    when(mockTodoRepository.addTodo(todoPayload))
        .thenAnswer((_) async => todoResponse);
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await usecase(todoPayload);
    // UseCase should simply return whatever was returned from the Repository
    expect(result, equals(todoResponse));
    // Verify that the method has been called on the Repository
    verify(mockTodoRepository.addTodo(todoPayload));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockTodoRepository);
  });
}