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
    //yield Loading();
    if (event is GetEventos) {
      yield Loading();
      try {
        List<Evento> eventi = await _userRepository.getAllEventos();
        yield Loaded(eventi: eventi, eventiFiltrati: eventi);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is DeleteEvento) {
      try {
        await _userRepository.deleteEventoById(event.evento.id);
        List<Evento> eventi = await _userRepository.getAllEventos();

        yield Loaded(eventi: eventi, eventiFiltrati: eventi);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is AddEvento) {
      try {
        await _userRepository.insertEvento(event.evento);
        List<Evento> eventi = await _userRepository.getAllEventos();

        yield Loaded(eventi: eventi, eventiFiltrati: eventi);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is FiltraEventos) {
      try {
        List<Evento> eventiF =
            await _userRepository.getEventosByDate(data: event.data);
        List<Evento> eventi = await _userRepository.getAllEventos();

        yield Loaded(eventi: eventi, eventiFiltrati: eventiF);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    }
  }
}
