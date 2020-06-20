import 'dart:convert';
import '../components/mensagem_item.dart';
import '../components/tarefa_card.dart';
import '../models/mensagem.dart';
import '../models/tarefa.dart';
import 'package:flutter/material.dart';
import '../models/aula.dart';
import '../utils/cores.dart';
import '../utils/session.dart';
import '../utils/config.dart';
import 'package:http/http.dart' as http;
import '../components/aula_detalhe_header.dart';

class AulaDetalhe extends StatefulWidget {
  AulaDetalhe({this.aula});
  final Aula aula;

  @override
  _AulaDetalheState createState() => _AulaDetalheState();
}

class _AulaDetalheState extends State<AulaDetalhe> {
  int _bottomIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _telas = [AulaInfo(aula: widget.aula), Discussao(aula: widget.aula)];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._bottomIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('Aula')),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Discussão'))
        ],
        onTap: (index) {
          setState(() {
            this._bottomIndex = index;
          });
        },
      ),
      body: _telas[this._bottomIndex],
    );
  }
}

class AulaInfo extends StatefulWidget {
  AulaInfo({this.aula});
  final Aula aula;

  @override
  _AulaInfoState createState() => _AulaInfoState();
}

class _AulaInfoState extends State<AulaInfo> {
  Session session = Session();

  Future<bool> isProfessor() async {
    return (await session.getUserInfo())['tipo_usuario'] == 'professor';
  }

  Future<List<Tarefa>> getTarefas() async {
    List<Tarefa> tarefas = [];
    http.Response res = await http.get("${Config.api}/aulas/${widget.aula.id}/tarefas");
    if (res.statusCode == 200) {
      for (var t in json.decode(res.body)) {
        Tarefa tarefa = Tarefa.fromJson(t);
        tarefas.add(tarefa);
      }
    }
    return tarefas;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<bool>(
        future: this.isProfessor(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AulaDetalheHeader(aula: widget.aula, isProfessor: snapshot.data),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Text("Tarefas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            ));
          return Container(
            height: 160,
            decoration: BoxDecoration(color: Cores.primary),
          );
        },
      ),
      Expanded(
        child: FutureBuilder<List<Tarefa>>(
            future: this.getTarefas(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      Tarefa tarefa = snapshot.data[index];
                      return TarefaCard(tarefa: tarefa);
                    });
              return Container();
            }),
      )
    ]);
  }
}

class Discussao extends StatefulWidget {
  Discussao({this.aula});
  final Aula aula;
  @override
  _DiscussaoState createState() => _DiscussaoState();
}

class _DiscussaoState extends State<Discussao> {
  FocusNode msgFocus;

  @override
  void initState() {
    super.initState();

    msgFocus = FocusNode();
  }

  @override
  void dispose() {
    msgFocus.dispose();

    super.dispose();
  }

  TextEditingController _mensagem = TextEditingController();
  Session session = Session();
  Future<List<Mensagem>> _getMensagens() async {
    List<Mensagem> mensagens = [];
    http.Response res = await http.get("${Config.api}/aulas/${widget.aula.id}/mensagens/");
    if (res.statusCode == 200) {
      for (var m in json.decode(res.body)) {
        Mensagem mensagem = Mensagem.fromJson(m);
        mensagens.add(mensagem);
      }
    }
    return mensagens;
  }

  void enviar() async {
    String mensagem = this._mensagem.text;
    if (mensagem.isEmpty) return;
    Map<String, dynamic> userInfo = await session.getUserInfo();
    Map<String, String> data = {"texto": mensagem, "imagem": ""};

    if (userInfo['tipo_usuario'] == 'professor')
      data['professor'] = userInfo['id'].toString();
    else if (userInfo['tipo_usuario'] == 'aluno') data['aluno'] = userInfo['id'].toString();

    setState(() {
      this._mensagem.text = "";
      msgFocus.unfocus();
    });
    http.post("${Config.api}/aulas/${widget.aula.id}/mensagens/", body: data).then((value) {
      if (value.statusCode == 201) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discussão'), elevation: 0),
      body: Container(
        child: Column(children: <Widget>[
          Expanded(
            flex: 8,
            child: FutureBuilder<List<Mensagem>>(
              future: this._getMensagens(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        Mensagem mensagem = snapshot.data[index];
                        return MensagemItem(mensagem: mensagem);
                      });
                }
                return Container();
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        child: TextFormField(
                          focusNode: this.msgFocus,
                          controller: this._mensagem,
                          style: TextStyle(color: Cores.dark),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              fillColor: Colors.grey[300].withOpacity(0.7),
                              filled: true,
                              hintStyle: TextStyle(color: Cores.dark.withOpacity(0.6)),
                              hintText: 'Sua mensagem'),
                        ),
                      )),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: this.enviar,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
