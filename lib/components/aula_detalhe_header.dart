import '../models/aula.dart';
import 'package:flutter/material.dart';
import '../telas/config_aula.dart';
import '../utils/cores.dart';
import './aula_opcoes.dart';
import '../telas/add_aluno.dart';
import '../telas/add_tarefa.dart';
import 'package:google_fonts/google_fonts.dart';

class AulaDetalheHeader extends StatelessWidget {
  AulaDetalheHeader({this.aula, this.isProfessor});
  final bool isProfessor;
  final Aula aula;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
                height: isProfessor ? 200 : 160,
                decoration: BoxDecoration(color: Cores.primary),
                padding: EdgeInsets.only(top: 30, bottom: isProfessor ? 70 : 30, left: 7, right: 7),
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
                      isProfessor
                          ? IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ConfigAula(
                                            aula: aula,
                                          ))),
                              color: Colors.white,
                              highlightColor: Colors.white,
                              focusColor: Colors.white,
                              splashColor: Colors.white)
                          : Container(),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(aula.nome,
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                  ],
                )),
            Container(height: isProfessor ? 70 : 0),
          ]),
        ),
        isProfessor
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
                          titulo: 'Adicionar aluno',
                          cor: Colors.purple[400],
                          icone: Icons.add,
                          acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddAluno(aula: aula)))),
                      Opcao(
                          titulo: 'Alunos',
                          cor: Colors.orange[400],
                          icone: Icons.people,
                          acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddAluno(aula: aula)))),
                      Opcao(
                          titulo: 'Adicionar tarefa',
                          cor: Colors.teal[400],
                          icone: Icons.assignment,
                          acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTarefa(aula: aula)))),
                      Opcao(
                        titulo: 'Fazer chamada',
                        cor: Colors.blue,
                        icone: Icons.list,
                        acao: () {
                          print('a');
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
