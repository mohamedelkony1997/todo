import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
part 'TaskModel.g.dart';
@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String? title;
  @HiveField(1)
  int? color;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? date;
  @HiveField(4)
  String? time;
  Task({
    required this.title,
    required this.color,
    required this.time,
    required this.date,
    required this.description,
  });
}
