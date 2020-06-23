import './aluno.dart';

class Chamada {
  int id;
  Aluno aluno;
  String presente;

  Chamada({this.id, this.aluno, this.presente});

  Chamada.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aluno = json['aluno'] != null ? new Aluno.fromJson(json['aluno']) : null;
    presente = json['presente'];
  }
}
