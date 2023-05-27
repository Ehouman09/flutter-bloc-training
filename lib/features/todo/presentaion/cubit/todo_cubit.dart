import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notey/core/error/failures.dart';
import 'package:notey/features/todo/data/models/todo_payload.dart';
import 'package:notey/features/todo/domain/entities/todo.dart';
import 'package:notey/features/todo/domain/usecases/add_todo.dart';
import 'package:notey/features/todo/domain/usecases/get_all_todos.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit({required this.getAllTodosUsecase, required this.addTodoUsecase}) : super(TodoInitial());

  final AddTodoUsecaseImpl addTodoUsecase;
  final GetAllTodosUsecaseImpl getAllTodosUsecase;

  createTodo(TodoPayload todoPayload) async {
    emit(TodoCreationInProgress());
    final Either<Failure,  Map> createTodoResult = await addTodoUsecase(todoPayload);
    createTodoResult.fold((Failure failure) {
      emit(
        TodoFailure(message: failure.message),
      );
    }, (Map result) {
      emit(
        TodoCreationSuccess(result: result),
      );
    });
  }

  getTodoList() async {
    emit(TodoListInProgress());
    final Either<Failure, List<Todo>> result = await getAllTodosUsecase();
    result.fold(
          (Failure failure) {
        emit(TodoFailure(message: failure.message));
      }, (List<Todo> localTodos) async {
        emit(TodoListSuccess(todos: localTodos));
      },
    );
  }
}
