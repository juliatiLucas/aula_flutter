import './aluno.dart';
import './aula.dart';
import './professor.dart';
import 'dart:convert' show utf8;
import 'package:intl/intl.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Mensagem {
  int id;
  String texto;
  String data;
  Professor professor;
  Aluno aluno;
  Aula aula;

  Mensagem({this.id, this.texto, this.data, this.professor, this.aluno, this.aula});

  Mensagem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    texto = utf8convert(json['texto']);
    data = new DateFormat('M/d H:m').format(DateTime.parse(json['data']).subtract(Duration(hours: 3)));
    professor = json['professor'] != null ? new Professor.fromJson(json['professor']) : null;
    aluno = json['aluno'] != null ? new Aluno.fromJson(json['aluno']) : null;
    aula = json['aula'] != null ? new Aula.fromJson(json['aula']) : null;
  }
}
