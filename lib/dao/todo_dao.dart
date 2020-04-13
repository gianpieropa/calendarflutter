import 'dart:async';
import 'package:calendar/database/database.dart';
import 'package:calendar/models/todo_model.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  newTodo(Todo newTodo) async {
    final db = await dbProvider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    int id = table.first["id"];
    table = await db.rawQuery("SELECT MAX(ordering)+1 as ordering FROM Todo");
    int ordering = table.first["ordering"];
    if (ordering == null) ordering = 1;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Todo (id,descrizione,ordering,done)"
        " VALUES (?,?,?,?)",
        [id, newTodo.descrizione, ordering, false]);
    return raw;
  }

  updateTodo(Todo newTodo) async {
    final db = await dbProvider.database;
    var res = await db.update("Todo", newTodo.toMap(),
        where: "id = ?", whereArgs: [newTodo.id]);
    return res;
  }

  getTodo(int id) async {
    final db = await dbProvider.database;
    var res = await db.query("Todo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await dbProvider.database;
    var res = await db.query("Todo", orderBy: 'ordering');
    print(res.toString());
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];

    return list;
  }

  deleteTodo(int id) async {
    final db = await dbProvider.database;
    return db.delete("Todo", where: "id = ?", whereArgs: [id]);
  }

  deleteAllTodos() async {
    final db = await dbProvider.database;
    db.rawDelete("Delete * from Todo");
  }

  reorderTodos(List<Todo> todos, int newIndex, int oldIndex) async {
    final db = await dbProvider.database;
    Todo newTodo;
    newTodo = todos.removeAt(oldIndex);
    todos.insert(newIndex, newTodo);
    for (int i = 0; i < todos.length; i++) {
      todos[i].ordering = i + 1;
    }
    for (var t in todos){
       await db.update("Todo", t.toMap(),
          where: "id = ?", whereArgs: [t.id]);
    }
    return getAllTodos();
  }
}
