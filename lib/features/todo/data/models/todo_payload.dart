import 'dart:convert';

class TodoPayload{
  TodoPayload({
    required this.color,
    required this.description,
    required this.title,
  });

  final String color;
  final String description;
  final String title;

  factory TodoPayload.fromMap(Map<String, dynamic> json) {
    return TodoPayload(
      title: json['title'],
      description: json['description'],
      color: json['color']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'color': color,
    };
  }

  String toJson() => json.encode(toMap());

  factory TodoPayload.fromJson(String source) => TodoPayload.fromMap(json.decode(source));
}