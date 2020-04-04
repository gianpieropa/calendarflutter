import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:calendar/models/evento_model.dart';

class EventoItem extends StatelessWidget {
  final Evento evento;

  EventoItem({
    Key key,
    @required this.evento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.blue,
      child: ListTile(
        leading: Icon(
                Icons.calendar_today,
                size: 30,
                color: Colors.white,
              ),
        title:   Text(
                evento.descrizione,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white),
              ),
      ),
    );
  }
}
