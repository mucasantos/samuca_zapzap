import 'package:flutter/material.dart';
import 'package:samuca_zapzap/util/appsettings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(AppSettings.usuarioAtual),



      ),
      body: Container(),
    );
  }
}
