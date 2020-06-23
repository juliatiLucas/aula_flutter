import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/data_chamada.dart';
import '../models/aula.dart';
import 'dart:convert';
import '../utils/config.dart';
import '../components/input.dart';
import 'package:intl/intl.dart';
import '../utils/cores.dart';
import './add_chamada.dart';
import 'package:http/http.dart' as http;

class ChamadaView extends StatefulWidget {
  ChamadaView({this.aula});
  final Aula aula;
  @override
  _ChamadaViewState createState() => _ChamadaViewState();
}

class _ChamadaViewState extends State<ChamadaView> {
  Future<List<DataChamada>> getDataChamadas() async {
    List<DataChamada> dataChamadas = [];
    await http.get("${Config.api}/aulas/${widget.aula.id}/data_chamada/").then((res) async {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);
        for (var dc in result) {
          DataChamada dataChamada = DataChamada.fromJson(dc);
          dataChamadas.add(dataChamada);
        }
      }
    });

    return dataChamadas;
  }

  void adicionar() async {
    await Navigator.of(context)
        .push(PageRouteBuilder(opaque: false, pageBuilder: (_, __, ___) => Dialogo(aula: widget.aula)))
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chamadas', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: this.adicionar,
          )
        ],
      ),
      body: Container(
        child: FutureBuilder<List<DataChamada>>(
            future: this.getDataChamadas(),
            builder: (_, snapshot) {
              Widget ret = Container();
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  break;
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  ret = Container(child: Center(child: CircularProgressIndicator()));
                  break;
                case ConnectionState.done:
                  ret = ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        DataChamada dataChamada = snapshot.data[index];
                        return ListTile(
                            title: Text(dataChamada.data),
                            onTap: () =>
                                Navigator.push(context, MaterialPageRoute(builder: (_) => AddChamada(dataChamada: dataChamada))));
                      });
                  break;
              }
              return ret;
            }),
      ),
    );
  }
}

class Dialogo extends StatefulWidget {
  Dialogo({this.aula});
  Aula aula;
  @override
  _DialogoState createState() => _DialogoState();
}

class _DialogoState extends State<Dialogo> {
  String data;

  criarDataChamada() {
    Map<String, String> data = {"aula": widget.aula.id.toString(), "data": this.data.split('/').reversed.toList().join('-')};
    http.post("${Config.api}/aulas/${widget.aula.id}/data_chamada/", body: data).then((res) {
      print(res.body);
      print(res.statusCode);
      Navigator.pop(context);
    });
  }

  void escolherData() async {
    var value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light()
              .copyWith(primaryColor: Colors.purple, accentColor: Cores.primary, secondaryHeaderColor: Cores.primary),
          child: child,
        );
      },
    );
    setState(() {
      this.data = new DateFormat('d/M/y').format(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Chamada'),
      titlePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      content: Container(
        width: 300,
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: <Widget>[
            DateInput(escolher: this.escolherData, valor: data, label: 'Data'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar', style: TextStyle(fontSize: 18)),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Criar', style: TextStyle(fontSize: 18)),
          onPressed: this.criarDataChamada,
        )
      ],
    );
  }
}
