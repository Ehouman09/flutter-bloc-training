import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

abstract class GetAllTodosUsecase<Type, Params> {
  Future<Either<Failure, Type>> call();
}

class GetAllTodosUsecaseImpl implements GetAllTodosUsecase{
  late final TodoRepository todoRepository;
  GetAllTodosUsecaseImpl(this.todoRepository);

  @override
  Future<Either<Failure, List<Todo>>> call() async{
    return await this.todoRepository.getAllTodos();
  }
}

class Params extends Equatable {
  final String color;
  final String description;
  final String title;

  Params({required this.title, required this.description, required this.color}) : super();

  @override
  List<Object?> get props => [title, description, color];
}