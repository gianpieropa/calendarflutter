import 'dart:async';
import 'package:calendar/database/database.dart';
import 'package:calendar/models/evento_model.dart';
import 'package:intl/intl.dart';

class EventoDao {
  final dbProvider = DatabaseProvider.dbProvider;

   newEvento(Evento newEvento) async {
    final db = await dbProvider.database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Evento");
    int id = table.first["id"];

    var formatter = new DateFormat('yyyy-MM-dd');
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Evento (id,descrizione,data_inizio,data_fine)"
        " VALUES (?,?,?,?)",
        [id, newEvento.descrizione, formatter.format(newEvento.dataInizio), formatter.format(newEvento.dataFine)]);
    print(raw);
    return raw;
  }


  updateEvento(Evento newEvento) async {
    final db = await dbProvider.database;
    var res = await db.update("Evento", newEvento.toMap(),
        where: "id = ?", whereArgs: [newEvento.id]);
    return res;
  }

  getEvento(int id) async {
    final db = await dbProvider.database;
    var res = await db.query("Evento", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Evento.fromMap(res.first) : null;
  }

  Future<List<Evento>> getAllEventos() async {
    final db = await dbProvider.database;
    var res = await db.query("Evento");
    List<Evento> list =
        res.isNotEmpty ? res.map((c) => Evento.fromMap(c)).toList() : [];
    return list;
  }
  Future<List<Evento>> getEventosByDay(DateTime data) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    final db = await dbProvider.database;
    var res = await db.query("Evento", where: "data_inizio = ?", whereArgs: [formatter.format(data)]);
    List<Evento> list =
        res.isNotEmpty ? res.map((c) => Evento.fromMap(c)).toList() : [];
    return list;
  }

  deleteEvento(int id) async {
    final db = await dbProvider.database;
    return db.delete("Evento", where: "id = ?", whereArgs: [id]);
  }

  deleteAllEventos() async {
    final db = await dbProvider.database;
    db.rawDelete("Delete * from Evento");
  }
}