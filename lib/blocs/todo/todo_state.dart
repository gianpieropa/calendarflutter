import 'package:calendar/models/todo_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TodoListState {
  final List<Todo> todos;
  final String message;

  TodoListState({this.todos, this.message, });
}
  
class InitialTodoListState extends TodoListState {}

class Loading extends TodoListState {}

class Error extends TodoListState {
  Error({@required String errorMessage}) : super(message: errorMessage);
}

class Loaded extends TodoListState {
  Loaded({@required List<Todo> todos, }) : super(todos: todos,);
}