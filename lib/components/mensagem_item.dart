import 'package:flutter/material.dart';
import '../models/mensagem.dart';
import '../utils/cores.dart';
import '../utils/session.dart';

class MensagemItem extends StatefulWidget {
  MensagemItem({this.mensagem});
  final Mensagem mensagem;
  @override
  _MensagemItemState createState() => _MensagemItemState();
}

class _MensagemItemState extends State<MensagemItem> {
  Session session = Session();

  Future<bool> isSelf(int userId) async {
    var userInfo = await session.getUserInfo();
    if (userId.toString() == userInfo['id'].toString()) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<bool>(
            future: isSelf(widget.mensagem.aluno != null ? widget.mensagem.aluno.id : widget.mensagem.professor.id),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Align(
                    alignment: snapshot.data ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300].withOpacity(0.70),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(snapshot.data ? 0 : 12),
                            bottomLeft: Radius.circular(snapshot.data ? 12 : 0),
                            topRight: Radius.circular(12),
                          )),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.mensagem.aluno != null ? widget.mensagem.aluno.nome : widget.mensagem.professor.nome,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: widget.mensagem.aluno != null ? Colors.black : Cores.primary),
                          ),
                          Opacity(opacity: 0.9, child: Text(widget.mensagem.texto, style: TextStyle(fontSize: 16)))
                        ],
                      ),
                    ));
              }
              return Container();
            }));
  }
}
