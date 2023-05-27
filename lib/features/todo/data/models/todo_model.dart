import 'dart:convert';

import '../../domain/entities/todo.dart';

class TodoModel extends Todo{
  TodoModel({
    required this.color,
    required this.description,
    required this.title,
    required this.id
  }) : super(id: id, title: title, description: description, color: color);

  final String color;
  final String description;
  final String title;
  final String id;

  factory TodoModel.fromMap(Map<String, dynamic> json, String id) {
    return TodoModel(
      title: json['title'],
      description: json['description'],
      color: json['color'],
      id: id,
    );
  }

  factory TodoModel.fromMap2(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'],
      description: json['description'],
      color: json['color'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': color,
    };
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source, String id) => TodoModel.fromMap(json.decode(source), id);

  factory TodoModel.fromCache(String source) => TodoModel.fromMap2(json.decode(source));
}