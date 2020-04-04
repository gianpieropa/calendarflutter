import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AddFormState extends Equatable {
  final String data;
  final bool isDataValid;
    final String dataFine;
  final bool isDataFineValid;
  final String descrizione;
  final bool isDescrizioneValid;
  final bool formSubmittedSuccessfully;

  bool get isFormValid => isDataValid && isDescrizioneValid;

  const AddFormState({
    @required this.data,
    @required this.isDataValid,
     @required this.dataFine,
    @required this.isDataFineValid,
    @required this.descrizione,
    @required this.isDescrizioneValid,
    @required this.formSubmittedSuccessfully,
  });

  factory AddFormState.initial() {
    return AddFormState(
      data: '',
      isDataValid: false,
      dataFine: '',
      isDataFineValid: false,
      descrizione: '',
      isDescrizioneValid: false,
      formSubmittedSuccessfully: false,
    );
  }

  AddFormState copyWith({
    String data,
    bool isDataValid,
      String dataFine,
    bool isDataFineValid,
    String descrizione,
    bool isDescrizioneValid,
    bool formSubmittedSuccessfully,
  }) {
    return AddFormState(
      data: data ?? this.data,
      isDataValid: isDataValid ?? this.isDataValid,
      dataFine: dataFine ?? this.dataFine,
      isDataFineValid: isDataFineValid ?? this.isDataFineValid,
      descrizione: descrizione ?? this.descrizione,
      isDescrizioneValid: isDescrizioneValid ?? this.isDescrizioneValid,
      formSubmittedSuccessfully:
          formSubmittedSuccessfully ?? this.formSubmittedSuccessfully,
    );
  }

  @override
  List<Object> get props => [
        data,
        isDataValid,
         dataFine,
        isDataFineValid,
        descrizione,
        isDescrizioneValid,
        formSubmittedSuccessfully,
      ];

  @override
  String toString() {
    return '''AddFormState {
      data: $data,
      isDatalValid: $isDataValid,
       dataFine: $dataFine,
      isDataFinelValid: $isDataFineValid,
      formSubmittedSuccessfully: $formSubmittedSuccessfully
    }''';
  }
}