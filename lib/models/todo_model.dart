import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromMap(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toMap());

class Todo {
  int id;
  String descrizione;
  int ordering;
  bool done;

  Todo({this.id, this.descrizione, this.ordering, this.done});

  factory Todo.fromMap(Map<String, dynamic> json) {
    bool done;
    if (json["done"] == 1)
      done = true;
    else
      done = false;
    return Todo(
        id: json["id"],
        descrizione: json["descrizione"],
        ordering: json["ordering"],
        done: done);
  }

  Map<String, dynamic> toMap() {
    int donev;
    if (done == true)
      donev = 1;
    else
      donev = 0;
    return {
      "id": id,
      "descrizione": descrizione,
      "ordering": ordering,
      "done": donev
    };
  }
}
