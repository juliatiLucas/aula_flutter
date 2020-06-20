import 'package:flutter/material.dart';
import '../models/aula.dart';
import '../models/aluno.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import 'dart:convert';

class AddAluno extends StatefulWidget {
  AddAluno({this.aula});
  final Aula aula;
  @override
  _AddAlunoState createState() => _AddAlunoState();
}

class _AddAlunoState extends State<AddAluno> {
  TextEditingController _pesquisa = TextEditingController();
  List<Aluno> _resultado = [];

  void buscar(String value) async {
    if (this._pesquisa.text.isEmpty) return;
    List<Aluno> alunos = [];
    http.get("${Config.api}/buscar-aluno/${_pesquisa.text}").then((res) {
      if (res.statusCode == 200) {
        for (var a in json.decode(res.body)) {
          Aluno aluno = Aluno.fromJson(a);
          alunos.add(aluno);
        }
        setState(() {
          this._resultado = alunos;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: TextFormField(
            controller: this._pesquisa,
            onFieldSubmitted: this.buscar,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.22),
                filled: true,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                hintText: 'Nome ou email do aluno'),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => this.buscar(null),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: this._resultado.length,
                    itemBuilder: (_, index) {
                      Aluno aluno = this._resultado[index];
                      return ListTile(
                        title: Text(aluno.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(aluno.email),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
