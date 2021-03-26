import 'package:flutter/material.dart';
import 'package:samuca_zapzap/Configurations.dart';
import 'package:samuca_zapzap/cadastro.dart';
import 'package:samuca_zapzap/home.dart';

class RouteGenerate {
  static const String ROTA_HOME = '/home';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Cadastro());

      case "/login":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case ROTA_HOME:
        return MaterialPageRoute(builder: (_) => Home());
      case "/configurations":
        return MaterialPageRoute(builder: (_) => Configurations());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Tela não encontrada!'),),
        body: Center(
          child: Text('Tela não encontrada!'),
        ),
      );

    });

  }
}
