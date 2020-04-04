import 'package:calendar/models/evento_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventoListEvent {
  final Evento evento;

  EventoListEvent({this.evento});
}

class GetEventos extends EventoListEvent {
  GetEventos() : super();
}

class DeleteEvento extends EventoListEvent {
  DeleteEvento({@required Evento evento}) : super(evento: evento);
}
class AddEvento extends EventoListEvent {
  AddEvento({@required Evento evento}) : super(evento: evento);
}