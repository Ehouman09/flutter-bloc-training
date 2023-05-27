part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoListInProgress extends TodoState {}

class TodoFailure extends TodoState {
  final String message;
  TodoFailure({required this.message});
}

class TodoListSuccess extends TodoState {
  final List<Todo> todos;

  TodoListSuccess({
    required this.todos,
  });

  @override
  List<Object> get props => [todos];
}

class TodoCreationInProgress extends TodoState {}

class TodoCreationSuccess extends TodoState {
  final Map result;

  TodoCreationSuccess({required this.result});
}

class TodoColorPicked extends TodoState {
  final Color color;

  TodoColorPicked({required this.color});
}