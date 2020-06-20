import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../utils/config.dart';

class ConfigAula extends StatefulWidget {
  ConfigAula({this.aula});
  final Aula aula;
  @override
  _ConfigAulaState createState() => _ConfigAulaState();
}

class _ConfigAulaState extends State<ConfigAula> {
  void deletar() async {
    await http.delete("${Config.api}/aulas/${widget.aula.id}/").then((res) {
      if (res.statusCode == 200) Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    });
  }

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
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Tem certeza que deseja deletar ${widget.aula.nome}?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancelar', style: TextStyle(fontSize: 18)),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('Sim', style: TextStyle(fontSize: 18)),
                              onPressed: this.deletar,
                            )
                          ],
                        ));
              },
            )
          ],
        ),
      ),
    );
  }
}
