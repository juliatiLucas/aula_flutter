import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:google_fonts/google_fonts.dart';

class AulaDetalhe extends StatefulWidget {
  AulaDetalhe({this.aula});
  final Aula aula;

  @override
  _AulaDetalheState createState() => _AulaDetalheState();
}

class _AulaDetalheState extends State<AulaDetalhe> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(widget.aula.nome), elevation: 0),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            width: size.width - 10,
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                Opcao(
                  titulo: 'Adicionar aluno',
                  cor: Colors.purple[400],
                  icone: Icons.people,
                  acao: () {
                    print('a');
                  },
                ),
                Opcao(
                  titulo: 'Adicionar tarefa',
                  cor: Colors.teal[400],
                  icone: Icons.assignment,
                  acao: () {
                    print('a');
                  },
                ),
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
          )
        ],
      )),
    );
  }
}

class Opcao extends StatelessWidget {
  Opcao({this.titulo, this.cor, this.icone, this.acao});
  final String titulo;
  final Color cor;
  final IconData icone;
  final Function acao;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: cor.withOpacity(0.45),
      splashColor: cor.withOpacity(0.45),
      enableFeedback: true,
      onTap: acao,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        width: 180,
        height: 100,
        decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: 0.4,
                child: Icon(icone, size: 60, color: Colors.white),
              ),
            ),
            Text(titulo, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    );
  }
}
