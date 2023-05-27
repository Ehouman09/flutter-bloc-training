import 'package:equatable/equatable.dart';

class Todo extends Equatable{
  Todo({
    required this.color,
    required this.description,
    required this.title,
    required this.id
  });

  final String color;
  final String description;
  final String title;
  final String id;

  @override
  List<Object> get props => [id, title, description, color];
}