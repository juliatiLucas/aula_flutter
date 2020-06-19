import 'package:flutter/material.dart';
import '../utils/session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/aula.dart';

class AddTarefa extends StatefulWidget {
  AddTarefa({this.aula});
  final Aula aula;
  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {
  void adicionar() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova tarefa', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
    );
  }
}
