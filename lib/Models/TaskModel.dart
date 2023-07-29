import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String id;
  String title;
  Color color;

  String description;
  DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.color,
   
    required this.description,
    required this.date,
  });
}

// @HiveType(typeId: 0)
// class Todo extends HiveObject {
//   @HiveField(0)
//   String? name;

//   @HiveField(1)
//   DateTime? date;

//   @HiveField(2)
//   TimeOfDay ? time;
//   @HiveField(3)
//   String ? description;
//   @HiveField(4)
//   Color ? color;