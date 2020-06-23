import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../utils/config.dart';
import '../components/input.dart';

class ConfigAula extends StatefulWidget {
  ConfigAula({this.aula});
  final Aula aula;
  @override
  _ConfigAulaState createState() => _ConfigAulaState();
}

class _ConfigAulaState extends State<ConfigAula> {
  TextEditingController _nome = TextEditingController();
  void deletar() async {
    await http.delete("${Config.api}/aulas/${widget.aula.id}/").then((res) {
      if (res.statusCode == 200) Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    });
  }

  void modalEditar() {
    setState(() {
      this._nome.text = widget.aula.nome;
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Editar ${widget.aula.nome}"),
              content: Container(
                width: 300,
                height: 120,
                child: Column(
                  children: <Widget>[
                    MyInput(controller: this._nome, hint: 'Nome'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar', style: TextStyle(fontSize: 18)),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('Salvar', style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    if (this._nome.text.isEmpty) return;
                    var data = {"nome": this._nome.text};
                    http.put("${Config.api}/aulas/${widget.aula.id}/", body: data).then((res) {
                      print(res.statusCode);
                      print(res.body);
                    }).catchError((err) {
                      print(err);
                    });
                  },
                )
              ],
            ));
  }

  void modalDeletar() {
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
              onTap: this.modalEditar,
            ),
            ListTile(
              title: Text('Deletar aula'),
              onTap: this.modalDeletar,
            )
          ],
        ),
      ),
    );
  }
}
