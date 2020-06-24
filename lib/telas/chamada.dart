import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/data_chamada.dart';
import '../models/aula.dart';
import 'dart:convert';
import '../utils/config.dart';
import '../components/input.dart';
import '../models/aluno.dart';
import '../models/chamada.dart';
import 'package:intl/intl.dart';
import '../utils/cores.dart';
import 'package:http/http.dart' as http;

class ChamadaView extends StatefulWidget {
  ChamadaView({this.aula});
  final Aula aula;
  @override
  _ChamadaViewState createState() => _ChamadaViewState();
}

class _ChamadaViewState extends State<ChamadaView> {
  Future<List<DataChamada>> getDataChamadas() async {
    List<DataChamada> dataChamadas = [];
    await http.get("${Config.api}/aulas/${widget.aula.id}/data_chamada/").then((res) async {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);

        for (var dc in result) {
          DataChamada dataChamada = DataChamada.fromJson(dc);
          dataChamadas.add(dataChamada);
        }
      }
    });

    return dataChamadas;
  }

  void adicionar() async {
    await Navigator.of(context)
        .push(PageRouteBuilder(opaque: false, pageBuilder: (_, __, ___) => Dialogo(aula: widget.aula)))
        .then((value) {
      setState(() {});
    });
  }

  void listaAlunos(DataChamada dataChamada) async {
    await Navigator.of(context)
        .push(PageRouteBuilder(
            opaque: false, pageBuilder: (_, __, ___) => DialogoLista(aula: widget.aula, dataChamada: dataChamada)))
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamadas', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: this.adicionar),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<DataChamada>>(
            future: this.getDataChamadas(),
            builder: (_, snapshot) {
              Widget ret = Container();
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  break;
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  ret = Container(child: Center(child: CircularProgressIndicator()));
                  break;
                case ConnectionState.done:
                  ret = ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        DataChamada dataChamada = snapshot.data[index];
                        return ListTile(
                            trailing: dataChamada.chamadas.length > 0
                                ? IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      Navigator.of(context).push(PageRouteBuilder(
                                          opaque: false, pageBuilder: (_, __, ___) => VerLista(dataChamada: dataChamada)));
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => this.listaAlunos(dataChamada),
                                  ),
                            title: Text(dataChamada.data),
                            onTap: () {});
                      });
                  break;
              }
              return ret;
            }),
      ),
    );
  }
}

class Dialogo extends StatefulWidget {
  Dialogo({this.aula});
  final Aula aula;
  @override
  _DialogoState createState() => _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  String data;

  criarDataChamada() {
    Map<String, String> data = {"aula": widget.aula.id.toString(), "data": this.data.split('/').reversed.toList().join('-')};
    http.post("${Config.api}/aulas/${widget.aula.id}/data_chamada/", body: data).then((res) {
      Navigator.pop(context);
    });
  }

  void escolherData() async {
    var value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light()
              .copyWith(primaryColor: Colors.purple, accentColor: Cores.primary, secondaryHeaderColor: Cores.primary),
          child: child,
        );
      },
    );
    if (value != null) {
      setState(() {
        this.data = new DateFormat('d/M/y').format(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: AlertDialog(
        title: Text('Nova Chamada'),
        titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        content: Container(
          width: 400,
          height: 120,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              DateInput(escolher: this.escolherData, valor: data, label: 'Data'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar', style: TextStyle(fontSize: 18)),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text('Criar', style: TextStyle(fontSize: 18)),
            onPressed: this.criarDataChamada,
          )
        ],
      ),
    );
  }
}

class DialogoLista extends StatefulWidget {
  DialogoLista({this.aula, this.dataChamada});
  final Aula aula;
  final DataChamada dataChamada;
  @override
  _DialogoListaState createState() => _DialogoListaState();
}

class _DialogoListaState extends State<DialogoLista> {
  List<Map<String, dynamic>> presentes = [];
  Future<List<Aluno>> getAlunos() async {
    List<Aluno> alunos = [];
    http.Response res = await http.get("${Config.api}/aulas/${widget.aula.id}/alunos");
    if (res.statusCode == 200) {
      for (var a in json.decode(res.body)) {
        Aluno aluno = Aluno.fromJson(a);
        alunos.add(aluno);
      }
    }
    return alunos;
  }

  void salvar(List<Map<String, dynamic>> alunos) {
    List alunosId = [];
    for (int i = 0; i < alunos.length; i++)
      alunosId.add({'id': alunos[i]['aluno'].id.toString(), 'presente': alunos[i]['presente'] ? '1' : '0'});

    Map<String, dynamic> data = {"alunos": json.encode(alunosId)};
    http.post("${Config.api}/data_chamada/${widget.dataChamada.id}/chamadas/", body: data).then((res) {
      if (res.statusCode == 201) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget gerarLista(List<Aluno> data) {
    List<Map<String, dynamic>> alunos = [];
    for (int i = 0; i < data.length; i++) alunos.add({'presente': false, 'aluno': data[i]});

    return CheckAluno(alunos: alunos, salvar: this.salvar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.32),
        body: FutureBuilder<List<Aluno>>(
          future: this.getAlunos(),
          builder: (_, snapshot) {
            Widget retorno;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.waiting:
                retorno = Container(height: 350, child: Center(child: CircularProgressIndicator()));
                break;
              case ConnectionState.done:
                if (snapshot.data.length > 0) {
                  retorno = AlertDialog(
                    title: Text('Lista de alunos'),
                    titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    content: Container(height: 350, width: 400, child: this.gerarLista(snapshot.data)),
                  );
                } else
                  retorno = AlertDialog(
                    title: Text('Lista de alunos'),
                    titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    content: Container(height: 150, width: 400, child: Center(child: Text('Sem alunos'))),
                    actions: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        child: Text('Fechar', style: TextStyle(fontSize: 18, color: Colors.blue)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );

                break;
            }

            return retorno;
          },
        ));
  }
}

class CheckAluno extends StatefulWidget {
  CheckAluno({this.alunos, this.salvar});
  final List<Map<String, dynamic>> alunos;
  final Function salvar;
  @override
  _CheckAlunoState createState() => _CheckAlunoState();
}

class _CheckAlunoState extends State<CheckAluno> {
  List<Map<String, dynamic>> data;
  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.alunos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 12,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              Map<String, dynamic> aluno = data[index];
              return CheckboxListTile(
                value: aluno['presente'],
                onChanged: (value) {
                  setState(() {
                    data[index]['presente'] = value;
                  });
                },
                title: Text(aluno['aluno'].nome),
                subtitle: Text(aluno['aluno'].email),
              );
            }),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Text('Cancelar', style: TextStyle(fontSize: 18, color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Text('Salvar', style: TextStyle(fontSize: 18, color: Colors.blue)),
            onPressed: () => widget.salvar(this.data),
          )
        ]),
      )
    ]);
  }
}

class VerLista extends StatefulWidget {
  VerLista({this.dataChamada});
  final DataChamada dataChamada;
  @override
  _VerListaState createState() => _VerListaState();
}

class _VerListaState extends State<VerLista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        body: AlertDialog(
          title: Text('Chamada ${widget.dataChamada.data}'),
          titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          content: Container(
              height: 350,
              width: 400,
              child: Column(children: [
                Expanded(
                  flex: 12,
                  child: ListView.builder(
                      itemCount: widget.dataChamada.chamadas.length,
                      itemBuilder: (_, index) {
                        Chamada chamada = widget.dataChamada.chamadas[index];

                        return CheckboxListTile(
                            value: chamada.presente,
                            onChanged: (value) {},
                            title: Text(chamada.aluno.nome),
                            subtitle: Text(chamada.aluno.email));
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Text('Fechar', style: TextStyle(fontSize: 18, color: Colors.blue)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ]),
                )
              ])),
        ));
  }
}
