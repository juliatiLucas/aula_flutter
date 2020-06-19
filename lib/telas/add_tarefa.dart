import 'package:flutter/material.dart';
import '../utils/session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/aula.dart';
import '../utils/cores.dart';
import '../components/input.dart';
import 'package:intl/intl.dart';

class AddTarefa extends StatefulWidget {
  AddTarefa({this.aula});
  final Aula aula;
  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {
  Session session = Session();
  TextEditingController _nome = TextEditingController();
  TextEditingController _descricao = TextEditingController();
  String _data;
  String _hora;
  void adicionar() async {}

  void escolherData() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light()
              .copyWith(primaryColor: Colors.purple, accentColor: Cores.primary, secondaryHeaderColor: Cores.primary),
          child: child,
        );
      },
    ).then((value) {
      setState(() {
        this._data = new DateFormat('d/M/y').format(value);
      });
    });
  }

  void escolherHora() {
    showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 0)).then((value) {
      setState(() {
        this._hora = value.format(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nova tarefa', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MyInput(controller: this._nome, hint: 'Nome'),
                MyInput(controller: this._descricao, hint: 'Descrição'),
                Text('Prazo de entrega'),
                Row(children: [
                  Expanded(child: DateInput(escolher: this.escolherData, valor: this._data, label: 'Data')),
                  Expanded(child: DateInput(escolher: this.escolherHora, valor: this._hora, label: 'Hora')),
                ]),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('Criar', style: TextStyle(color: Cores.primary, fontSize: 18)),
                  onPressed: this.adicionar,
                ),
              ],
            )));
  }
}
