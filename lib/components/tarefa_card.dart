import 'package:flutter/material.dart';
import 'package:gerenciador_aula/utils/session.dart';
import '../models/tarefa.dart';
import 'package:intl/intl.dart';
import '../utils/config.dart';
import 'package:http/http.dart' as http;

class TarefaCard extends StatelessWidget {
  TarefaCard({this.tarefa, this.acao});
  final Function acao;
  final Tarefa tarefa;

  Widget isPast(String data) {
    String formatada = new DateFormat('d/M/y HH:mm:ss').format(DateTime.parse(data));
    int timestamp = DateTime.parse(data).millisecondsSinceEpoch;
    int agora = DateTime.now().millisecondsSinceEpoch;

    bool passado = agora - timestamp > 0;
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          decoration: BoxDecoration(
            color: passado ? Colors.red.withOpacity(0.5) : Colors.blue.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(formatada),
        ));
  }

  void excluir() {
  
    http.delete("${Config.api}/tarefas/${tarefa.id}/").then((res) {
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        this.acao();
      }
    });
  }

  Future<bool> isProfessor() async {
    Session session = Session();
    return (await session.getUserInfo())['tipo_usuario'] == 'professor';
  }

  void selectPopup(selected) async {
    switch (selected) {
      case 'Excluir':
        this.excluir();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['Excluir'];
    return FutureBuilder(
      future: this.isProfessor(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                  elevation: 2,
                  child: InkWell(
                    splashColor: Colors.grey.withOpacity(0.2),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              tarefa.nome,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            PopupMenuButton<String>(
                              child: IconButton(icon: Icon(Icons.more_vert, size: 26), onPressed: null),
                              onSelected: (selected) => this.selectPopup(selected),
                              itemBuilder: (context) {
                                return options.map((String op) {
                                  return PopupMenuItem<String>(value: op, child: Text(op));
                                }).toList();
                              },
                            ),
                          ]),
                          Opacity(
                            opacity: 0.87,
                            child: Text(
                              tarefa.descricao,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          isPast(tarefa.prazo)
                        ],
                      ),
                    ),
                  )));
        } else
          return Container();
      },
    );
  }
}
