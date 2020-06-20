import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Aluno {
  int id;
  String nome;
  String email;
  String senha;

  Aluno({this.id, this.nome, this.email, this.senha});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> aluno = {
      "nome": this.nome,
      "email": this.email,
      "senha": this.senha,
    };

    if (this.id != null) aluno['id'] = this.id;

    return aluno;
  }

  Aluno.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = utf8convert(json['nome']);
    email = utf8convert(json['email']);
    senha = utf8convert(json['senha']);
  }
}
