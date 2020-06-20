import './professor.dart';
import 'package:intl/intl.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Aula {
  int id;
  String nome;
  String data;
  Professor professor;

  Aula({this.nome, this.professor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> aula = {
      "nome": this.nome,
      "data": this.data,
      "professor": this.professor,
    };

    if (this.id != null) aula['id'] = this.id;

    return aula;
  }

  Aula.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = utf8convert(json['nome']);
    professor = json['professor'] != null ? new Professor.fromJson(json['professor']) : null;
    data = new DateFormat('d/M/y HH:mm:ss').format(DateTime.parse(json['data']));
  }
}
