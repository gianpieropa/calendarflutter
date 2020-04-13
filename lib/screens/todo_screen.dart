import 'package:calendar/models/todo_model.dart';
import 'package:calendar/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar/blocs/todo/todo.dart';
import 'package:reorderables/reorderables.dart';

class TodosScreen extends StatefulWidget {
  TodosScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodosScreenState createState() => new _TodosScreenState(title: title);
}

class _TodosScreenState extends State<TodosScreen> {
  final String title;
  final TextEditingController _descrizioneController = TextEditingController();
  _TodosScreenState({this.title});

  
  @override
  Widget build(BuildContext context) {
    final _queryData = MediaQuery.of(context);
    return BlocBuilder<TodoListBloc, TodoListState>(builder: (context, state) {
      if (state is Loaded) {
     
        return new Scaffold(
            backgroundColor: Colors.blue,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(_queryData.size.height * 0.065),
              child: AppBar(
                /*
                  actions: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 5),
                      child: Text("Todos",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _queryData.textScaleFactor*17)),
                    )
                  ],*/
                elevation: 0.0,
                backgroundColor: Colors.blue,
              ),
            ),
            body: ReorderableColumn(
                header:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              left: _queryData.size.width * 0.08,
                              right: _queryData.size.width * 0.08,
                              bottom: _queryData.size.width * 0.03),
                          child: Text(
                            "Todos",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: _queryData.textScaleFactor * 17),
                          )),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              bottom: _queryData.size.height * 0.03),
                          height: _queryData.size.height * 0.07,
                          width: _queryData.size.width * 0.64,
                          child: TextFormField(
                            controller: _descrizioneController,
                            decoration: new InputDecoration(
                              hintText: "Aggiungi todo ",
                              contentPadding: EdgeInsets.all(10.0),
                              filled: true,
                              fillColor: Colors.lightBlue[50],
                              enabledBorder: new OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(
                                    color: Colors.lightBlue[50]),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(
                                    color: Colors.lightBlue[50]),
                              ),
                              border: new OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.circular(15.0),
                                borderSide: new BorderSide(
                                    color: Colors.lightBlue[50]),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            autovalidate: true,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                bottom: _queryData.size.height * 0.03),
                            child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white),
                              onPressed: _onSumbitPressed,
                            )),
                      ])
                ]),
                crossAxisAlignment: CrossAxisAlignment.start,
                 padding: EdgeInsets.symmetric(
                          horizontal: _queryData.size.width * 0.08),
                children: state.todos.map((todo) {
                  return TodoItem(
                    key: ValueKey("$todo"),
                    todo: todo,
                  );
                }).toList(),
                onReorder: (oldindex, index) {
               
                 BlocProvider.of<TodoListBloc>(context).add(ReorderTodo(todos:state.todos,oldIndex: oldindex,newIndex: index));
                }));
      } else if (state is Loading) {
        return Container(
          color: Colors.white,
        );
      } else {
        return Center(
          child: Text('failed to fetch posts'),
        );
      }
    });
  }

  @override
  void dispose() {
    _descrizioneController.dispose();
    super.dispose();
  }

  void _onSumbitPressed() {
    if (_descrizioneController.text != "") {
      Todo newTodo = Todo(descrizione: _descrizioneController.text);
      BlocProvider.of<TodoListBloc>(context).add(AddTodo(todo: newTodo));
      _descrizioneController.clear();
    }
  }
}
