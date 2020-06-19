import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAluno extends StatefulWidget {
  AddAluno({this.aula});
  final Aula aula;
  @override
  _AddAlunoState createState() => _AddAlunoState();
}

class _AddAlunoState extends State<AddAluno> {
  TextEditingController _pesquisa = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: TextFormField(
            controller: this._pesquisa,
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
            onPressed: () {},
          )
        ],
      ),
      body: Container(),
    );
  }
}
