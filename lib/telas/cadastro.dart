import 'package:flutter/material.dart';
import '../utils/cores.dart';
import 'package:flushbar/flushbar.dart';
import '../utils/config.dart';
import 'package:http/http.dart' as http;

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _nome = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  String _tipoUsuario = 'aluno';

  void cadastrar() async {
    String nome = this._nome.text;
    String email = this._email.text;
    String senha = this._senha.text;
    String url = "";

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarSnack(titulo: "Erro", mensagem: "Preencha todos os campos!");
      return;
    }

    if (_tipoUsuario == 'professor') {
      url = "${Config.api}/professores/";
    } else if (_tipoUsuario == 'aluno') {
      url = "${Config.api}/alunos/";
    }

    Map<String, String> data = {
      "nome": nome,
      "email": email,
      "senha": senha,
    };

    http.post(url, body: data).then((res) {
      if (res.statusCode == 400)
        mostrarSnack(titulo: "Erro", mensagem: "E-mail já cadastrado!");
      else if (res.statusCode == 201) Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
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

  void _handleRadioValueChange(String value) {
    setState(() {
      this._tipoUsuario = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Cores.light, Cores.primary])),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: 330,
            height: 380,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: this._nome,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: this._email,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                ),
                TextField(
                  controller: this._senha,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                ),
                SizedBox(height: 25),
                Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Radio(
                            groupValue: this._tipoUsuario,
                            onChanged: _handleRadioValueChange,
                            value: 'aluno',
                          ),
                          Text('Aluno')
                        ]),
                        Row(children: <Widget>[
                          Radio(
                            groupValue: this._tipoUsuario,
                            onChanged: _handleRadioValueChange,
                            value: 'professor',
                          ),
                          Text('Professor')
                        ])
                      ],
                    )),
                SizedBox(height: 15),
                Row(children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                      color: Colors.white,
                      child: Text('Cancelar', style: TextStyle(fontSize: 18)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                      color: Colors.white,
                      child: Text('Criar', style: TextStyle(fontSize: 18)),
                      onPressed: this.cadastrar,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
