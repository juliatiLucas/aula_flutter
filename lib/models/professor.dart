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
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
  }
}
