import 'package:flutter/material.dart';
import '../utils/session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/aula.dart';
import '../utils/cores.dart';
import '../telas/aula_detalhe.dart';
import 'package:flushbar/flushbar.dart';
import '../components/input.dart';
import 'package:intl/intl.dart';
import '../utils/config.dart';

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
  String _data = '';
  String _hora = '';
  void adicionar() async {
    String nome = this._nome.text;
    String descricao = this._descricao.text;

    if (this._data.isEmpty || this._hora.isEmpty || descricao.isEmpty || nome.isEmpty) {
      mostrarSnack(titulo: 'Erro', mensagem: 'Preencha todos os campos!');
      return;
    }

    Map<String, String> data = {
      "aula": widget.aula.id.toString(),
      "nome": nome,
      "descricao": descricao,
      "prazo": "${_data.split('/').reversed.toList().join('-')} $_hora"
    };

    http.post("${Config.api}/tarefas/", body: data).then((res) async {
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 201) {
        mostrarSnack(titulo: 'Sucesso', mensagem: 'Tarefa criada.');
        await Future.delayed(Duration(milliseconds: 2500), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => AulaDetalhe(aula: widget.aula)), (Route<dynamic> route) => false);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  mostrarSnack({String titulo, String mensagem}) {
    Flushbar(
      title: titulo,
      message: mensagem,
      animationDuration: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 2500),
    )..show(context);
  }

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
        this._data = new DateFormat('d/MM/y').format(value);
      });
    });
  }

  void escolherHora() {
    showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 0)).then((value) {
      setState(() {
        this._hora = value.format(context) + ':00';
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
                RoundButton(
                  text: 'Criar',
                  onPressed: this.adicionar,
                )
              ],
            )));
  }
}
