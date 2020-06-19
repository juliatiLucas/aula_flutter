import 'package:flutter/material.dart';
import '../telas/aula_detalhe.dart';
import '../models/aula.dart';
import '../utils/cores.dart';

class AulaItem extends StatelessWidget {
  AulaItem({this.aula});
  final Aula aula;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.purple.withOpacity(0.45),
      splashColor: Colors.purple.withOpacity(0.45),
      enableFeedback: true,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AulaDetalhe(
                    aula: aula,
                  ))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              aula.nome.length > 20 ? aula.nome.substring(0, 20) + '...' : aula.nome,
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(color: Cores.light.withOpacity(0.7), borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(aula.data, style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
