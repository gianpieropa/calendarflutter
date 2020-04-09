import 'package:calendar/blocs/todo/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _queryData = MediaQuery.of(context);

    return Dismissible(
        onDismissed: (direction) {
          BlocProvider.of<TodoListBloc>(context).add(DeleteTodo(todo: todo));
        },
        key: ValueKey(todo.id.toString()),
        child: Container(
                    margin: EdgeInsets.only(bottom: _queryData.size.height*0.02),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          color:Colors.white

          ),
          child: CheckboxListTile(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            title: Text(todo.ordering.toString()+") "+todo.descrizione, style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize:  _queryData.textScaleFactor * 16,
                            color: Colors.black),),
            value: todo.done,
            onChanged: (newValue) {  BlocProvider.of<TodoListBloc>(context)
            .add(UpdateTodo(todo: Todo(descrizione: todo.descrizione,id: todo.id,ordering: todo.ordering,done: newValue)));},
            controlAffinity:
                ListTileControlAffinity.trailing, //  <-- leading Checkbox
          ),
        ));
  }
}
