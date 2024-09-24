import 'package:dayly/models/frequency.dart';
import 'package:dayly/models/task.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDac extends ChangeNotifier {
  var tasks = <Task>[];

  TaskDac() {
    createDatabase();
    getAllTasks(DateTime.now());
  }

  Future createDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE repeat_frequency(id INTEGER PRIMARY KEY, name TEXT)');

        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT, description TEXT, is_done TEXT, due_date TEXT, is_repeating TEXT, frequency INTEGER)',
        );
      },
      version: 2,
    );
  }

  Future insertTask(Task task) async {
    try {
      final database = openDatabase(join(await getDatabasesPath(), 'tasks.db'));

      final db = await database;

      await db.insert('tasks', task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      notifyListeners();
    } on Exception catch (exception) {
      print(exception);
    }
  }

  Future<void> getAllTasks([DateTime? selectedDate]) async {
    final database = openDatabase(join(await getDatabasesPath(), 'tasks.db'));

    final db = await database;

    var result = await db.query('tasks');

    if (selectedDate != null) {
      var filteredTasks = result.where((task) {
        DateTime taskDate = DateTime.parse(task['due_date'] as String);
        return taskDate.year == selectedDate.year &&
            taskDate.month == selectedDate.month &&
            taskDate.day == selectedDate.day;
      }).toList();

      if (filteredTasks.isEmpty) {
        return;
      }

      tasks = [
        for (final {
              'id': id,
              'name': vname as String,
              'description': vdescription as String,
              'is_done': visDone,
              'due_date': vdueDate as String,
              'is_repeating': visRepating
            } in filteredTasks)
          Task(
              name: vname,
              isDone: (visDone is String ? visDone == "1" : visDone == 1),
              description: vdescription,
              dueDate: DateTime.tryParse(vdueDate),
              isRepeating: (visRepating is String
                  ? visRepating == "1"
                  : visRepating == 1),
              frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.hours))
      ];
      notifyListeners();
    } else {
      var filterDate = DateTime.now();
      var filteredTasks = result.where((task) {
        DateTime taskDate = DateTime.parse(task['due_date'] as String);
        return taskDate.year == filterDate.year &&
            taskDate.month == filterDate.month &&
            taskDate.day == filterDate.day;
      }).toList();

      tasks = [
        for (final {
              'id': id,
              'name': vname as String,
              'description': vdescription as String,
              'is_done': visDone,
              'due_date': vdueDate as String,
              'is_repeating': visRepating
            } in filteredTasks)
          Task(
              name: vname,
              isDone: (visDone is String ? visDone == "1" : visDone == 1),
              description: vdescription,
              dueDate: DateTime.tryParse(vdueDate),
              isRepeating: (visRepating is String
                  ? visRepating == "1"
                  : visRepating == 1),
              frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.hours)),
      ];
      notifyListeners();
    }
  }
}
