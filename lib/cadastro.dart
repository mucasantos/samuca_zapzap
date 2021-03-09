import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samuca_zapzap/home.dart';
import 'package:samuca_zapzap/model/Usuario.dart';
import 'package:samuca_zapzap/util/appsettings.dart';
import 'package:samuca_zapzap/util/colors.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Controladores

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = '';
  bool _isLogin = true;

  _validarCampos(bool isLogin) {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (isLogin) {
      _logarUsuario(email, senha);
      return;
    }

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains('@')) {
        if (senha.isNotEmpty && senha.length > 6) {
          setState(() {
            _mensagemErro = '';
          });
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;

          _cadastrarUsuario(usuario);
        } else {
          setState(() {
            _mensagemErro = 'A senha precisa ter 6 ou mais caracters';
          });
        }
      } else {
        setState(() {
          _mensagemErro = 'Formato de e-mail inválido!';
        });
      }
    } else {
      setState(() {
        _mensagemErro = 'O nome precisa ser preenchido';
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      print(firebaseUser.user.uid);
      setState(() {
        AppSettings.usuarioAtual = firebaseUser.user.uid;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }).catchError((error) {
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        setState(() {
          _mensagemErro = 'O e-mail informado já está em uso.';
        });
      }
    });
  }

  _logarUsuario(String email, String senha) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {
      print(firebaseUser.user.uid);
      setState(() {
        AppSettings.usuarioAtual = firebaseUser.user.uid;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }).catchError((error) {
      setState(() {
        _mensagemErro = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: kColorFundo),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                imagemTela(_isLogin),
                Text(
                  'MucaZaap',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(
                  height: 30,
                ),
                if (!_isLogin)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNome,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: 'Nome',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'E-mail',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: 'Senha',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      _isLogin ? 'Entrar' : 'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: kColorBotao,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onPressed: () {
                      _validarCampos(_isLogin);
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      _isLogin
                          ? 'Não tem conta? Cadastre-se'
                          : 'Já é cadastrado? Entre.',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ),
                Center(
                    child: Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget imagemTela(bool isLogin) {
  return Image.asset(
    isLogin ? 'imagens/chat.png' : 'imagens/userAdd.png',
    width: 200,
    height: 150,
    color: kColorBotao,
  );
}
