import 'dart:convert';

import 'package:equatable/equatable.dart';

Evento eventoFromJson(String str) => Evento.fromMap(json.decode(str));

String eventoToJson(Evento data) => json.encode(data.toMap());

class Evento extends Equatable {
  final int id;
  final String descrizione;
  final DateTime dataInizio;
  final DateTime dataFine;
  final String labelColor;

  Evento({
    this.id,
    this.descrizione,
    this.dataInizio,
    this.dataFine,
    this.labelColor,
  });
  @override
  List<Object> get props => [id, descrizione, dataInizio, dataFine];

  factory Evento.fromMap(Map<String, dynamic> json) => Evento(
        id: json["id"],
        descrizione: json["descrizione"],
        dataInizio: DateTime.parse(json["data_inizio"]),
        dataFine: DateTime.parse(json["data_fine"]),
        labelColor: json["label_color"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "descrizione": descrizione,
        "data_inizio":
            "${dataInizio.year.toString().padLeft(4, '0')}-${dataInizio.month.toString().padLeft(2, '0')}-${dataInizio.day.toString().padLeft(2, '0')}",
        "data_fine":
            "${dataFine.year.toString().padLeft(4, '0')}-${dataFine.month.toString().padLeft(2, '0')}-${dataFine.day.toString().padLeft(2, '0')}",
        "label_color": labelColor,
      };
}
