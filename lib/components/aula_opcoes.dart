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
