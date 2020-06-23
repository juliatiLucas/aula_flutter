import 'package:intl/intl.dart';
import './chamada.dart';

class DataChamada {
  int id;
  int aula;
  String data;
  List<Chamada> chamadas;

  DataChamada({this.id, this.aula, this.data, this.chamadas});

  DataChamada.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aula = json['aula'];
    data = new DateFormat('d/M/y').format(DateTime.parse(json['data']));
    if (json['chamadas'] != null) {
      chamadas = new List<Chamada>();
      json['chamadas'].forEach((c) {
        chamadas.add(new Chamada.fromJson(c));
      });
    }
  }
}