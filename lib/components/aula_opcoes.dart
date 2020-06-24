import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        width: 180,
        decoration: BoxDecoration(color: widget.cor, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: widget.cor,
          child: InkWell(
            onTap: widget.acao,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7.5),
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
          ),
        ));
  }
}
