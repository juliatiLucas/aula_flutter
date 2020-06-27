import 'package:flutter/material.dart';
import '../models/aula.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../utils/config.dart';
import '../components/input.dart';
import '../components/aula_opcoes.dart';

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
                height: 80,
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
                      if (res.statusCode == 200) {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                      }
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 220,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'Configurações de ${widget.aula.nome}',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              height: 120,
              child: Opcao(titulo: 'Editar aula', cor: Color(0xfff5ad1d), icone: Icons.edit, acao: this.modalEditar),
            )),
            Expanded(
                child: Container(
                    height: 120,
                    child: Opcao(titulo: 'Excluir aula', cor: Colors.red, icone: Icons.delete, acao: this.modalDeletar))),
          ],
        ),
      ]),
    );
  }
}
