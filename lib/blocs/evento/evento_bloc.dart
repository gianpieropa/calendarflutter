import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calendar/models/evento_model.dart';
import 'package:calendar/repository/evento_repository.dart';
import './evento.dart';


class EventoListBloc extends Bloc<EventoListEvent, EventoListState> {
  final _userRepository = EventoRepository();
  
  @override
  EventoListState get initialState => InitialEventoListState();

  @override
  Stream<EventoListState> mapEventToState(EventoListEvent event) async* {
    yield Loading();
    if (event is GetEventos) {
      try {
        List<Evento> eventi = await _userRepository.getAllEventos();
        yield Loaded(eventi: eventi);
      } catch(e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is DeleteEvento) {
      try {
        await _userRepository.deleteEventoById(event.evento.id);
        yield Loaded(eventi: await _userRepository.getAllEventos());
      } catch(e) {
        yield Error(errorMessage: e.toString());
      }
    }
    else if (event is AddEvento) {
      try {
        await _userRepository.insertEvento(event.evento);
        yield Loaded(eventi: await _userRepository.getAllEventos());
      } catch(e) {
        yield Error(errorMessage: e.toString());
      }
    }
  
  }
}