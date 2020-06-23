import 'package:flutter/material.dart';
import '../models/data_chamada.dart';
import '../models/aluno.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';

class AddChamada extends StatefulWidget {
  AddChamada({this.dataChamada});
  final DataChamada dataChamada;
  @override
  _AddChamadaState createState() => _AddChamadaState();
}

class _AddChamadaState extends State<AddChamada> {
  Future<List<Aluno>> getAlunos() async {
    List<Aluno> alunos = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presenças', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: <Widget>[
          Tooltip(
              message: 'Lista de presença',
              child: IconButton(
                icon: Icon(Icons.check_box),
                onPressed: () {},
              ))
        ],
      ),
    );
  }
}

class Dialogo extends StatefulWidget {
  Dialogo({this.alunos});
  List<Aluno> alunos;
  @override
  _DialogoState createState() => _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  String data;

  void checar() async {}

  void salvar() async {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Chamada'),
      titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      content: Container(
        width: 300,
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar', style: TextStyle(fontSize: 18)),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Salvar', style: TextStyle(fontSize: 18)),
          onPressed: this.salvar,
        )
      ],
    );
  }
}
