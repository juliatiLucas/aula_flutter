import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/cores.dart';
import 'package:flushbar/flushbar.dart';
import '../utils/session.dart';
import '../utils/config.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  Session session = Session();
  String _tipoUsuario = 'aluno';
  bool _carregando = false;

  void login() async {
    String email = this._email.text;
    String senha = this._senha.text;

    if (email.isEmpty || senha.isEmpty) {
      mostrarSnack(titulo: "Erro", mensagem: "Preencha todos os campos!");
      return;
    }
    setState(() {
      this._carregando = true;
    });

    Map<String, String> data = {"email": email, "senha": senha, "tipo_usuario": this._tipoUsuario};

    http.post("${Config.api}/login/", body: data).then((res) async {
      if (res.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(res.body);
        userData['tipo_usuario'] = _tipoUsuario;
        await session.login(userData);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      } else if (res.statusCode == 400) mostrarSnack(titulo: "Erro", mensagem: "E-mail ou senha incorretos!");
      setState(() {
        this._carregando = false;
      });
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Cores.light, Cores.primary])),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: 330,
              height: 480,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: this._email,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: this._senha,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                  ),
                  SizedBox(height: 25),
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                    color: Colors.white,
                    child: Text('Entrar', style: TextStyle(fontSize: 18)),
                    onPressed: _carregando ? null : this.login,
                  ),
                  Opacity(
                    opacity: 0.85,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Esqueceu a senha?', style: TextStyle(fontSize: 16, color: Colors.white)),
                          GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/cadastro'),
                              child: Text('Cadastrar-se', style: TextStyle(fontSize: 16, color: Colors.white))),
                        ],
                      ),
                    ),
                  ),
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
                ],
              ),
            ),
          ),
        ),
        Positioned(
            width: size.width,
            bottom: 5,
            child: this._carregando
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(Cores.light)))
                : Container()),
      ]),
    );
  }
}
