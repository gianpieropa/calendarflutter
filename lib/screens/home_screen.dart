import 'package:calendar/blocs/evento/evento_state.dart';
import 'package:calendar/showCalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar/blocs/blocs.dart';
import 'package:calendar/models/evento_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventoListBloc, EventoListState>(
      builder: (context, activeTab) {
        return Scaffold( backgroundColor: Colors.blue,
        appBar: AppBar(
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15, right: 10),
              child: Text("2020",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            )
          ],
          elevation: 0.0,
          backgroundColor: Colors.blue,
        ),
          body: ShowCalendar(),
          
        );
      },
    );
  }
}