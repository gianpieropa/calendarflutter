import 'package:calendar/models/evento_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventoListState {
  final List<Evento> eventi;
  final String message;
  final List<Evento> eventiFiltrati;

  EventoListState({this.eventi, this.message, this.eventiFiltrati});
}
  
class InitialEventoListState extends EventoListState {}

class Loading extends EventoListState {}

class Error extends EventoListState {
  Error({@required String errorMessage}) : super(message: errorMessage);
}

class Loaded extends EventoListState {
  Loaded({@required List<Evento> eventi, @required List<Evento> eventiFiltrati}) : super(eventi: eventi,eventiFiltrati:eventiFiltrati);
}