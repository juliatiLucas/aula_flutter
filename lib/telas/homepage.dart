import '../models/aula.dart';
import '../utils/config.dart';
import 'package:flutter/material.dart';
import '../utils/cores.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../components/aula_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Session session = Session();
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

  Future<String> _tipoUsuario() async => (await session.getUserInfo())['tipo_usuario'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Cores.primary,
      appBar: AppBar(
        title: FutureBuilder(
          future: this._tipoUsuario(),
          builder: (_, snapshot) {
            if (snapshot.hasData)
              return Text(snapshot.data == 'aluno' ? 'Área do aluno' : 'Área do professor',
                  style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold));

            return Container();
          },
        ),
        elevation: 0,
        actions: <Widget>[
          FutureBuilder(
            future: this._tipoUsuario(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data == 'professor'
                    ? IconButton(
                        icon: Icon(Icons.add, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/add-aula'))
                    : Container();
              }

              return Container();
            },
          ),
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
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Cores.primary,
          ),
        ),
        ListTile(
          leading: Icon(Icons.sync),
          title: Text('Sincronizar'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair'),
          onTap: this.sair,
        )
      ])),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       title: Text('Aulas'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       title: Text('Convites'),
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   onTap: _onItemTapped,
      // ),

      body: Column(children: [
        Expanded(flex: 1, child: SizedBox(height: 5)),
        Expanded(
          flex: 15,
          child: Stack(
            children: <Widget>[
              Positioned(
                width: size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    height: size.height - 150,
                    child: Column(
                      children: <Widget>[
                        Text('Suas turmas', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                        return AulaItem(aula: aula);
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
