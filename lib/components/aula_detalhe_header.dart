import '../models/aula.dart';
import 'package:flutter/material.dart';
import '../telas/config_aula.dart';
import '../utils/cores.dart';
import './aula_opcoes.dart';
import '../telas/add_aluno.dart';
import '../models/aluno.dart';
import '../telas/add_tarefa.dart';
import '../telas/chamada.dart';
import '../utils/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AulaDetalheHeader extends StatefulWidget {
  final bool isProfessor;
  final Aula aula;
  AulaDetalheHeader({this.aula, this.isProfessor});

  @override
  _AulaDetalheHeaderState createState() => _AulaDetalheHeaderState();
}

class _AulaDetalheHeaderState extends State<AulaDetalheHeader> {
  void removerAluno(int id) async {
    http.delete("${Config.api}/alunos/$id/aulas/${widget.aula.id}/").then((res) {
      if (res.statusCode == 200) {
        Navigator.pop(context);
        setState(() {});
      }
    });
  }

  modalAlunos() async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Alunos'),
              titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              content: FutureBuilder<List<Aluno>>(
                future: this.getAlunos(),
                builder: (_, snapshot) {
                  Widget retorno;
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      break;
                    case ConnectionState.active:
                      break;
                    case ConnectionState.waiting:
                      retorno = Container(height: 350, width: 380, child: Center(child: CircularProgressIndicator()));
                      break;
                    case ConnectionState.done:
                      if (snapshot.data.length > 0) {
                        retorno = Container(
                            height: 350,
                            width: 380,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index) {
                                  Aluno aluno = snapshot.data[index];
                                  return ListTile(
                                    title: Text(aluno.nome),
                                    subtitle: Text(aluno.email),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () => this.removerAluno(aluno.id),
                                    ),
                                  );
                                }));
                      } else
                        retorno = Container(height: 150, width: 380, child: Center(child: Text('Sem alunos')));

                      break;
                  }
                  return retorno;
                },
              ),
              actions: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text('Fechar', style: TextStyle(fontSize: 18, color: Colors.blue)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }

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

  void mostrarBottom() {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (_) {
          return ConfigAula(aula: widget.aula);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
                height: widget.isProfessor ? 200 : 160,
                decoration: BoxDecoration(color: Cores.primary),
                padding: EdgeInsets.only(top: 30, bottom: widget.isProfessor ? 70 : 30, left: 7, right: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.white,
                          highlightColor: Colors.white,
                          focusColor: Colors.white,
                          splashColor: Colors.white),
                      widget.isProfessor
                          ? IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigAula(aula: widget.aula)));
                                this.mostrarBottom();
                              },
                              color: Colors.white,
                              highlightColor: Colors.white,
                              focusColor: Colors.white,
                              splashColor: Colors.white)
                          : Container(),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(widget.aula.nome,
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  ],
                )),
            Container(height: widget.isProfessor ? 70 : 0),
          ]),
        ),
        widget.isProfessor
            ? Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Container(
                  height: 115,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      Opcao(
                        titulo: 'Fazer chamada',
                        cor: Colors.blue,
                        icone: Icons.list,
                        acao: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChamadaView(aula: widget.aula))),
                      ),
                      Opcao(
                          titulo: 'Adicionar aluno',
                          cor: Colors.purple[400],
                          icone: Icons.add,
                          acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddAluno(aula: widget.aula)))),
                      Opcao(titulo: 'Alunos', cor: Colors.orange[400], icone: Icons.people, acao: this.modalAlunos),
                      Opcao(
                          titulo: 'Adicionar tarefa',
                          cor: Colors.teal[400],
                          icone: Icons.assignment,
                          acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTarefa(aula: widget.aula)))),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
