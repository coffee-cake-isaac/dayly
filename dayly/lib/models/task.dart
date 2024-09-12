import 'package:dayly/models/frequency.dart';

class Task {
  String? name;
  bool isDone = false;
  String? description;
  DateTime? dueDate;
  bool isRepeating = false;
  RepeatFrequency? frequency;

  Task({
    this.name,
    this.isDone = false,
    this.description,
    this.dueDate,
    this.isRepeating = false,
    this.frequency,
  });
}
