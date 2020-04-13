import 'package:calendar/blocs/todo/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _queryData = MediaQuery.of(context);

    return ReorderableWidget(
        reorderable: true,
        key: ValueKey(todo),
        child: Dismissible(
            onDismissed: (direction) {
              BlocProvider.of<TodoListBloc>(context)
                  .add(DeleteTodo(todo: todo));
            },
            key: ValueKey(todo.id.toString()),
            child: Container(
              decoration: BoxDecoration(color:Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
              padding: EdgeInsets.only(left:10),
              margin: EdgeInsets.only(bottom: _queryData.size.height * 0.02),
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(child:   Text( todo.descrizione,
                    style: TextStyle(
                      decoration: todo.done?TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w400,
                        fontSize: _queryData.textScaleFactor * 16,
                        color: Colors.black),
                  ),),
                
                  Checkbox(
                    activeColor: Colors.blue,
                    checkColor: Colors.blue,
                    value: todo.done,
                    onChanged: (newValue) {
                      BlocProvider.of<TodoListBloc>(context).add(UpdateTodo(
                          todo: Todo(
                              descrizione: todo.descrizione,
                              id: todo.id,
                              ordering: todo.ordering,
                              done: newValue)));
                    },
                  ),
                ],
              ),
            )));
  }
}
