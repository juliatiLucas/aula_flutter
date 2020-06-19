import 'package:flutter/material.dart';
import './telas/homepage.dart';
import './telas/login.dart';
import './telas/cadastro.dart';
import './utils/cores.dart';
import 'telas/add_aula.dart';
import 'utils/session.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco de Dados N2',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => Login(),
        '/cadastro': (context) => Cadastro(),
        '/home': (context) => HomePage(),
        '/add-aula': (context) => AddAula(),
      },
      theme: ThemeData(
        primaryColor: Cores.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    this.isAuthenticated();
  }

  Future<bool> isAuthenticated() async {
    Session session = Session();
    bool isAuthenticated = false;
    await Future.delayed(Duration(milliseconds: 2500), () async {
      isAuthenticated = await session.isAuthenticated();
    });
    return isAuthenticated;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.isAuthenticated(),
      builder: (_, snapshot) {
        Widget ret = SplashScreen();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            ret = SplashScreen();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.none:
            break;
          case ConnectionState.done:
            if (snapshot.hasData)
              ret = snapshot.data ? HomePage() : Login();
            else
              ret = Login();
            break;
        }
        return ret;
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.primary,
      body: Center(
        child: Container(child: Icon(Icons.library_books, size: 64, color: Colors.white)),
      ),
    );
  }
}
