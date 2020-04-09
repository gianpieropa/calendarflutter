import 'package:calendar/models/todo_model.dart';
import 'package:calendar/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TodosList extends StatelessWidget {
  TodosList({Key key, @required this.todos}) : super(key: key);
  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final _queryData = MediaQuery.of(context);

    if (todos.length > 0) {
      return ReorderableListView(
          children: todos.map((todo) {
            return TodoItem(
              key: ValueKey("$todo"),
              todo: todo,
            );
          }).toList(),
          onReorder: (oldindex, index) {
            print(oldindex);
            print(index);
          });
    } else {
      return Image(image: AssetImage('assets/no_events.png'));
    }
  }
}
