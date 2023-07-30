import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
part 'TaskModel.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final int? color;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? date;
  @HiveField(4)
  final String? time;
  Task({
    required this.title,
    required this.color,
    required this.time,
    required this.date,
    required this.description,
  });
 Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        time = json['time'],
        color = json['color'],
        date = json['date'],
        description = json['description']  ;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'color': color,
      'date': date,
      'description': description,
    };
  }

}
