import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import 'package:intl/intl.dart';

class TarefaCard extends StatelessWidget {
  TarefaCard({this.tarefa});
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

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      tarefa.nome,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
  }
}
