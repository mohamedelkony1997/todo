import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
part 'TaskModel.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final int? color;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? date;
  @HiveField(5)
  final String? time;
  Task({
    required this.title,
    required this.color,
    required this.id,
    required this.time,
    required this.date,
    required this.description,
  });
  Task copyWith(
      {String? id,
      String? title,
      String? description,
      String? date,
      String? time,
      int? color}) {
    return Task(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      color: color ?? this.color,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        time = json['time'],
        color = json['color'],
        id = json['id'],
        date = json['date'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'color': color,
      'id': id,
      'date': date,
      'description': description,
    };
  }
}
