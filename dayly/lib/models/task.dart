import 'package:dayly/models/frequency.dart';

class Task {
  int? id;
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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'is_done': isDone.toString(),
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'is_repeating': isRepeating.toString(),
      'frequency': frequency?.unit.index
    };
  }
}
