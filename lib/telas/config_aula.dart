import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigAula extends StatefulWidget {
  ConfigAula({this.aula});
  final Aula aula;
  @override
  _ConfigAulaState createState() => _ConfigAulaState();
}

class _ConfigAulaState extends State<ConfigAula> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text('Editar aula'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Deletar aula'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
