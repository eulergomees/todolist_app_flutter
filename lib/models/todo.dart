import 'dart:convert';
class Todo {
  Todo({required this.tittle, required this.dateTime});

  String tittle;
  DateTime dateTime;

  Todo.fromJson(Map<String, dynamic> json)
      : tittle = json['tittle'],
        dateTime = DateTime.parse(json['datetime']);

  Map<String, dynamic> toJson() {
    return {
      'tittle': tittle,
      'datetime': dateTime.toIso8601String(),
    };
  }
}
