import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notey/core/error/failures.dart';
import 'package:notey/features/todo/domain/entities/todo.dart';
import 'package:notey/features/todo/domain/usecases/get_all_todos.dart';

import 'add_todo_test.mocks.dart';

void main() {
  late GetAllTodosUsecaseImpl usecase;
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    usecase = GetAllTodosUsecaseImpl(mockTodoRepository);
  });

  test(
    'should get all todos from the repository',
        () async {
      Either<Failure, List<Todo>> todoListRes = Right<Failure, List<Todo>>([
        Todo(id: "kzd", title: "Titre1", description: "Description1", color: "Red"),
        Todo(id: "ret", title: "Titre2", description: "Description2", color: "Blue")
      ]);
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockTodoRepository.getAllTodos())
          .thenAnswer((_) async => todoListRes);
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase();
      // UseCase should simply return whatever was returned from the Repository
      expect(result, todoListRes);
      // Verify that the method has been called on the Repository
      verify(mockTodoRepository.getAllTodos());
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockTodoRepository);
    },
  );
}