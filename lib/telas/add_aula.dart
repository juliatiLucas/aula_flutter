import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/session.dart';
import 'package:http/http.dart' as http;

class AddAula extends StatefulWidget {
  @override
  _AddAulaState createState() => _AddAulaState();
}

class _AddAulaState extends State<AddAula> {
  void adicionar() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova aula', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
    );
  }
}
