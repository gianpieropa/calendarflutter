import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AddFormEvent extends Equatable {
  const AddFormEvent();

  @override
  List<Object> get props => [];
}

class DataChanged extends AddFormEvent {
  final String data;

  const DataChanged({@required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataChanged { data: $data }';
}
class DataFineChanged extends AddFormEvent {
  final String data;

  const DataFineChanged({@required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'DataFineChanged { data: $data }';
}
class DescrizioneChanged extends AddFormEvent {
  final String descrizione;

  const DescrizioneChanged({@required this.descrizione});

  @override
  List<Object> get props => [descrizione];

  @override
  String toString() => 'DescrizioneChanged { password: $descrizione }';
}

class FormSubmitted extends AddFormEvent {}

class FormReset extends AddFormEvent {}