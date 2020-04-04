import 'package:calendar/dao/evento_dao.dart';
import 'package:calendar/models/evento_model.dart';

class EventoRepository {
  final eventoDao = EventoDao();

  Future getAllEventos() => eventoDao.getAllEventos();
  Future getEventosByDate({DateTime data}) => eventoDao.getEventosByDay(data);

  Future insertEvento(Evento evento) => eventoDao.newEvento(evento);

  Future updateEvento(Evento evento) => eventoDao.updateEvento(evento);

  Future deleteEventoById(int id) => eventoDao.deleteEvento(id);

  //We are not going to use this in the demo
  Future deleteAllEventos() => eventoDao.deleteAllEventos();
}