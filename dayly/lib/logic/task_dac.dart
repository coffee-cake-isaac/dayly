import 'package:dayly/models/frequency.dart';
import 'package:dayly/models/task.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDac extends GetxController {
  var tasks = <Task>[].obs;

  Future createDatabase() async {
    print("Creating database");
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
      final database = openDatabase(
          // Set the path to the database. Note: Using the `join` function from the
          // `path` package is best practice to ensure the path is correctly
          // constructed for each platform.
          join(await getDatabasesPath(), 'tasks.db'));

      final db = await database;

      await db.insert('tasks', task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  Future<List<Task>> getAllTasks() async {
    final database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'tasks.db'));

    final db = await database;

    var result = await db.query('tasks');

    tasks = RxList([
      for (final {
            'id': id,
            'name': vname as String,
            'description': vdescription as String,
            'is_done': visDone,
            'due_date': vdueDate as String,
            'is_repeating': visRepating
          } in result)
        Task(
            name: vname,
            isDone: (visDone is String ? visDone == "1" : visDone == 1),
            description: vdescription,
            dueDate: DateTime.tryParse(vdueDate),
            isRepeating:
                (visRepating is String ? visRepating == "1" : visRepating == 1),
            frequency: RepeatFrequency(interval: 1, unit: RepeatUnit.hours)),
    ]);

    return tasks;
  }
}
