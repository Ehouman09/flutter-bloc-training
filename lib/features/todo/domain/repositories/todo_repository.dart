import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/todo_payload.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<Todo>>> getAllTodos();
  Future<Either<Failure, Map>> addTodo(TodoPayload todoPayload);
}