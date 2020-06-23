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
    if (nome.isEmpty) {
      mostrarSnack(titulo: 'Erro', mensagem: 'Preencha todos os campos!');
      return;
    }
    if ((await session.getUserInfo())['tipo_usuario'] != 'professor') Navigator.pop(context);

    Map<String, String> data = {
      "nome": nome,
      "professor": (await session.getUserInfo())['id'].toString(),
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
