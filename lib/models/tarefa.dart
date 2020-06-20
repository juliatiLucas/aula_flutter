import './aula.dart';
import 'dart:convert' show utf8;


String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Tarefa {
  int id;
  String nome;
  String descricao;
  Aula aula;
  String prazo;

  Tarefa({this.id, this.nome, this.descricao, this.aula, this.prazo});

  Tarefa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = utf8convert(json['nome']);
    descricao = utf8convert(json['descricao']);
    prazo = json['prazo'];
    aula = json['aula'] != null ? new Aula.fromJson(json['aula']) : null;
  }
}
