import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calendar/models/todo_model.dart';
import 'package:calendar/repository/todo_repository.dart';
import './todo.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final _userRepository = TodoRepository();

  @override
  TodoListState get initialState => InitialTodoListState();

  @override
  Stream<TodoListState> mapEventToState(TodoListEvent event) async* {
    yield Loading();
    if (event is GetTodos) {
      //yield Loading();
      try {
        List<Todo> todos = await _userRepository.getAllTodos();
        yield Loaded(todos: todos);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is DeleteTodo) {
      try {
        await _userRepository.deleteTodoById(event.todo.id);
        List<Todo> todos = await _userRepository.getAllTodos();

        yield Loaded(todos: todos);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is AddTodo) {
      try {
        await _userRepository.insertTodo(event.todo);
        List<Todo> todos = await _userRepository.getAllTodos();

        yield Loaded(todos: todos);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } 
    else if (event is UpdateTodo) {
      try {
        await _userRepository.updateTodo(event.todo);
        List<Todo> todos = await _userRepository.getAllTodos();

        yield Loaded(todos: todos);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } 
    else if (event is ReorderTodo) {
      try {
        List<Todo> todos = await _userRepository.reorderTodos(event.todos,event.newIndex,event.oldIndex);
        yield Loaded(todos: todos);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } 
  }
}
