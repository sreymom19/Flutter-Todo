import 'package:my_flutter_todo/models/task.dart';
import 'package:my_flutter_todo/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTERER PRIMARY KEY,taskID INTERGER, title TEXT, isDone INTERGER)");
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskID = 0;
    Database db = await database();
    await db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {taskID = value});
    return taskID;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database db = await database();
    await db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database db = await database();
    await db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  insertTodo(Todo todo) async {
    Database db = await database();
    await db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database db = await database();
    List<Map<String, dynamic>> taskMap = await db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskid) async {
    Database db = await database();
    List<Map<String, dynamic>> todoMap =
        await db.rawQuery("SELECT * FROM todo WHERE taskid = $taskid");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskID: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database db = await database();
    await db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }
}
