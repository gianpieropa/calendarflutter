import 'package:calendar/dao/todo_dao.dart';
import 'package:calendar/models/todo_model.dart';

class TodoRepository {
  final todoDao = TodoDao();

  Future getAllTodos() => todoDao.getAllTodos();

  Future insertTodo(Todo todo) => todoDao.newTodo(todo);

  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);

  Future deleteTodoById(int id) => todoDao.deleteTodo(id);
  
  Future deleteAllTodos() => todoDao.deleteAllTodos();
}