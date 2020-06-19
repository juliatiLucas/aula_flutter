import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/cores.dart';
import 'add_aluno.dart';
import 'add_tarefa.dart';
import 'config_aula.dart';

class AulaDetalhe extends StatefulWidget {
  AulaDetalhe({this.aula});
  final Aula aula;

  @override
  _AulaDetalheState createState() => _AulaDetalheState();
}

class _AulaDetalheState extends State<AulaDetalhe> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          child: Stack(
        children: <Widget>[
          Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(
                  height: 200,
                  decoration: BoxDecoration(color: Cores.primary),
                  padding: EdgeInsets.only(top: 25, bottom: 70, left: 10, right: 10),
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
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ConfigAula(
                                          aula: widget.aula,
                                        ))),
                            color: Colors.white,
                            highlightColor: Colors.white,
                            focusColor: Colors.white,
                            splashColor: Colors.white),
                      ]),
                      Text(widget.aula.nome,
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                    ],
                  )),
            ]),
          ),
          Positioned(
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
                      icone: Icons.people,
                      acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddAluno(aula: widget.aula)))),
                  Opcao(
                      titulo: 'Adicionar tarefa',
                      cor: Colors.teal[400],
                      icone: Icons.assignment,
                      acao: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTarefa(aula: widget.aula)))),
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
          ),
        ],
      )),
    );
  }
}

class Opcao extends StatefulWidget {
  Opcao({this.titulo, this.cor, this.icone, this.acao});
  final String titulo;
  final Color cor;
  final IconData icone;
  final Function acao;
  @override
  _OpcaoState createState() => _OpcaoState();
}

class _OpcaoState extends State<Opcao> {
  bool active = false;
  void click() async {
    setState(() {
      active = !active;
    });
    await Future.delayed(Duration(milliseconds: 480), () {
      setState(() {
        active = !active;
      });
    });
    widget.acao();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 120),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          width: 180,
          decoration: BoxDecoration(
              color: widget.cor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: active ? [BoxShadow(color: widget.cor.withOpacity(0.97), offset: Offset(0, 0), blurRadius: 4)] : []),
          child: Container(
              child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                child: Opacity(
                  opacity: 0.4,
                  child: Icon(widget.icone, size: 60, color: Colors.white),
                ),
              ),
              Text(widget.titulo, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
            ],
          )),
        ));
  }
}
