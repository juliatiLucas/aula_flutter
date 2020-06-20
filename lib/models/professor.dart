import 'dart:convert' show utf8;

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class Professor {
  int id;
  String nome;
  String email;
  String senha;

  Professor({this.id, this.nome, this.email, this.senha});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> professor = {
      "nome": this.nome,
      "email": this.email,
      "senha": this.senha,
    };

    if (this.id != null) professor['id'] = this.id;

    return professor;
  }

  Professor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = utf8convert(json['nome']);
    email = utf8convert(json['email']);
    senha = utf8convert(json['senha']);
  }
}
