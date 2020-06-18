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
}
