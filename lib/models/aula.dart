import './professor.dart';
import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Aula {
  int id;
  String nome;
  Professor professor;

  Aula({this.nome, this.professor});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> aula = {
      "nome": this.nome,
      "professor": this.professor,
    };

    if (this.id != null) aula['id'] = this.id;

    return aula;
  }

  Aula.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = utf8convert(json['nome']);
    professor = json['professor'] != null ? new Professor.fromJson(json['professor']) : null;
  }
}
