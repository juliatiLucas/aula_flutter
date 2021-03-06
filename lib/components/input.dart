import 'package:flutter/material.dart';
import '../utils/cores.dart';

class MyInput extends StatelessWidget {
  MyInput({this.controller, this.hint, this.readOnly = false, this.autoFocus = false});
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final bool autoFocus;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: TextFormField(
          controller: this.controller,
          readOnly: this.readOnly,
          style: TextStyle(color: Cores.dark),
          autofocus: this.autoFocus,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Cores.primary, width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 2)),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              fillColor: Colors.grey.withOpacity(0.22),
              filled: true,
              hintStyle: TextStyle(color: Cores.dark.withOpacity(0.6)),
              hintText: hint),
        ),
      ),
    );
  }
}

class DateInput extends StatelessWidget {
  DateInput({this.escolher, this.valor, this.label});
  final Function escolher;
  final String valor;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      height: 58,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.22), borderRadius: BorderRadius.all(Radius.circular(6))),
      child: InkWell(
          onTap: this.escolher,
          child: Align(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Text(this.valor != null && valor.isNotEmpty ? valor : this.label,
                    style: TextStyle(
                        color: this.valor != null && valor.isNotEmpty ? Cores.dark : Cores.dark.withOpacity(0.6), fontSize: 16)),
              ),
              alignment: Alignment.centerLeft)),
    );
  }
}

class RoundButton extends StatelessWidget {
  RoundButton({this.text, this.onPressed});
  final Function onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      child: FlatButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: this.onPressed,
      ),
    );
  }
}
