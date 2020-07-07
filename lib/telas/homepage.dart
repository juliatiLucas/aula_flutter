import '../models/aula.dart';
import '../utils/config.dart';
import 'package:flutter/material.dart';
import '../utils/cores.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/session.dart';
import 'package:http/http.dart' as http;
import './aula_detalhe.dart';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import '../components/input.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Session session = Session();
  TextEditingController _nome = TextEditingController();
  List<String> options = ['Recarregar', 'Sair'];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void selectPopup(selected) async {
    switch (selected) {
      case 'Recarregar':
        setState(() {});
        break;
      case 'Sair':
        this.sair();
        break;
    }
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

  mostrarSnack({String titulo, String mensagem}) {
    Flushbar(
      title: titulo,
      message: mensagem,
      animationDuration: Duration(milliseconds: 500),
      duration: Duration(milliseconds: 2500),
    )..show(context);
  }

  void addAula() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('Nova aula'),
            titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            contentPadding: EdgeInsets.zero,
            content: Container(
                width: 400,
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MyInput(controller: this._nome, hint: 'Nome', autoFocus: true),
                    RoundButton(
                      text: 'Criar',
                      onPressed: this.adicionar,
                    ),
                  ],
                ))));
  }

  void sair() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Tem certeza que deseja sair?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar', style: TextStyle(fontSize: 18)),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('Sim', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    session.logout();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                  },
                )
              ],
            ));
  }

  Future<List<Aula>> _getAulas() async {
    List<Aula> aulas = [];
    var userData = await session.getUserInfo();
    String url = "";

    if (userData['tipo_usuario'] == "aluno")
      url = "${Config.api}/alunos/${userData['id']}/aulas/";
    else
      url = "${Config.api}/professores/${userData['id']}/aulas/";

    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      for (var a in json.decode(res.body)) {
        Aula aula = Aula.fromJson(a);
        aulas.add(aula);
      }
    }

    return aulas;
  }

  Future<Map<String, dynamic>> getUserInfo() async => await session.getUserInfo();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Cores.primary,
      appBar: AppBar(
        title: FutureBuilder(
          future: this.getUserInfo(),
          builder: (_, snapshot) {
            if (snapshot.hasData)
              return Text(snapshot.data['tipo_usuario'] == 'aluno' ? 'Área do aluno' : 'Área do professor',
                  style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold));

            return Container();
          },
        ),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            child: IconButton(icon: Icon(Icons.more_vert, size: 26, color: Colors.white), onPressed: null),
            onSelected: (selected) => this.selectPopup(selected),
            itemBuilder: (context) {
              return this.options.map((String op) {
                return PopupMenuItem<String>(value: op, child: Text(op));
              }).toList();
            },
          )
        ],
      ),
      floatingActionButton: FutureBuilder(
        future: this.getUserInfo(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data['tipo_usuario'] == 'professor'
                ? FloatingActionButton(elevation: 3.1, child: Icon(Icons.add, color: Colors.white), onPressed: this.addAula)
                : Container();
          }

          return Container();
        },
      ),
      drawer: FutureBuilder(
        future: this.getUserInfo(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Drawer(
                child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              DrawerHeader(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          snapshot.data['nome'],
                          style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Opacity(
                          opacity: 0.82,
                          child: Text(snapshot.data['email'], style: TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ]),
                      Opacity(
                        opacity: 0.82,
                        child:
                            Text("Logado como: ${snapshot.data['email']}", style: TextStyle(fontSize: 14, color: Colors.white)),
                      )
                    ]),
                decoration: BoxDecoration(
                  color: Cores.primary,
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                onTap: this.sair,
              )
            ]));
          }

          return Container();
        },
      ),
      body: Column(children: [
        SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            ),
            child: Container(
              width: size.width,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text('Suas turmas', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: FutureBuilder<List<Aula>>(
                            future: this._getAulas(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(height: 40, width: 40, child: Center(child: CircularProgressIndicator()));
                              } else if (snapshot.connectionState == ConnectionState.done) {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      Aula aula = snapshot.data[index];
                                      return ListTile(
                                        onTap: () =>
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => AulaDetalhe(aula: aula))),
                                        title: Text(aula.nome, style: TextStyle(fontSize: 18)),
                                        subtitle: Text("Professor: ${aula.professor.nome}"),
                                      );
                                    });
                              }
                              return Container();
                            })),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
