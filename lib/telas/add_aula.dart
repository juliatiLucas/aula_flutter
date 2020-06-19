import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/cores.dart';
import '../utils/session.dart';
import 'package:http/http.dart' as http;
import '../utils/session.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import '../components/input.dart';
import '../utils/config.dart';

class AddAula extends StatefulWidget {
  @override
  _AddAulaState createState() => _AddAulaState();
}

class _AddAulaState extends State<AddAula> {
  Session session = Session();
  TextEditingController _nome = TextEditingController();
  String _data;
  String _hora;

  mostrarSnack({String titulo, String mensagem}) {
    Flushbar(
      title: titulo,
      message: mensagem,
      animationDuration: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 2500),
    )..show(context);
  }

  void adicionar() async {
    String nome = this._nome.text;
    if (nome.isEmpty || this._data.isEmpty || this._hora.isEmpty) {
      mostrarSnack(titulo: 'Erro', mensagem: 'Preencha todos os campos!');
      return;
    }
    if ((await session.getUserInfo())['tipo_usuario'] != 'professor') Navigator.pop(context);

    Map<String, String> data = {
      "nome": nome,
      "professor": (await session.getUserInfo())['id'].toString(),
      "data": "${this._data.split('/').reversed.toList().join('-')} ${this._hora}"
    };

    await http.post("${Config.api}/aulas/", body: data).then((res) async {
      if (res.statusCode == 201) {
        mostrarSnack(titulo: 'Sucesso', mensagem: 'Aula criada.');
        await Future.delayed(Duration(milliseconds: 2500), () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
        });
      }
    });
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
        title: Text('Nova aula', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MyInput(controller: this._nome, hint: 'Nome'),
              DateInput(escolher: this.escolherData, valor: this._data, label: 'Data'),
              DateInput(escolher: this.escolherHora, valor: this._hora, label: 'Hora'),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Criar', style: TextStyle(color: Cores.primary, fontSize: 18)),
                onPressed: this.adicionar,
              ),
            ],
          )),
    );
  }
}

