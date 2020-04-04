import 'dart:async';
import 'package:bloc/bloc.dart';
import 'addeventoform_event.dart';
import './addeventoform_state.dart';

class AddFormBloc extends Bloc<AddFormEvent, AddFormState> {
 

  @override
  AddFormState get initialState => AddFormState.initial();


  @override
  Stream<AddFormState> mapEventToState(
    AddFormEvent event,
  ) async* {
    if (event is DataChanged) {
      yield state.copyWith(
        data: event.data,
        isDataValid: _isDataValid(event.data),
      );
    }
    if (event is DescrizioneChanged) {
      yield state.copyWith(
        descrizione: event.descrizione,
        isDescrizioneValid: _isDescrizioneValid(event.descrizione),
      );
    }
    if (event is DataFineChanged) {
      yield state.copyWith(
        dataFine: event.data,
        isDataFineValid: _isDataFineValid(event.data),
      );
    }
    if (event is FormSubmitted) {
      yield state.copyWith(formSubmittedSuccessfully: true);
    }
    if (event is FormReset) {
      yield AddFormState.initial();
    }
  }

  bool _isDataValid(String data) {
    if (data!=null){
      return true;
    }
    return false;
  }
 bool _isDataFineValid(String data) {
    if (data!=null){
      return true;
    }
    return false;
  }
  bool _isDescrizioneValid(String descrizione) {
    if (descrizione!=null){
      return true;
    }
    return false;
  }
}