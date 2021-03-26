import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samuca_zapzap/cadastro.dart';
import 'package:samuca_zapzap/model/itemMenu.dart';
import 'package:samuca_zapzap/telas/abacontatos.dart';
import 'package:samuca_zapzap/telas/abaconversas.dart';
import 'package:samuca_zapzap/util/appsettings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _trabController;
  Firestore db = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trabController = TabController(length: 2, vsync: this);
    _recoverUserData();
  }

  List<ItemMenu> itensMenu = [
    ItemMenu(
        'Configurações',
        Icon(
          Icons.auto_fix_high,
          color: Colors.black,
        )),
    ItemMenu(
        'Sair',
        Icon(
          Icons.logout,
          color: Colors.black,
        ))
  ];
  _escolhaMenuItem(ItemMenu itemEscolhido) {
    Navigator.pushNamed(context, '/configurations');
    if (itemEscolhido.nome == 'Sair') {
      _deslogarUsuario();
    } else {
      print(itemEscolhido.nome);
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    AppSettings.userId = '';
    AppSettings.myProfileImage = '';
    AppSettings.myEmail = '';
    AppSettings.usuarioAtual = '';
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  _recoverUserData() async {
    DocumentSnapshot snapshot =
        await db.collection('usuarios').document(AppSettings.userId).get();

    Map<String, dynamic> dados = snapshot.data;

setState(() {
  AppSettings.usuarioAtual = dados['nome'];
  AppSettings.myEmail = dados['email'];
  AppSettings.myProfileImage = dados['urlImage'] ?? '';
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, " + AppSettings.usuarioAtual),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          controller: _trabController,
          tabs: <Widget>[
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            )
          ],
        ),
        actions: <Widget>[
          /*
          O PopupMenu utiliza o PopupMenuItem que pode ser uma String (para nome),
          ou um objeto qualquer.
          Neste caso, eu criei a classe itemMenu (dentro de model) que tem o nome e o
          icon para este nome.
          Assim, tudo dever ser relacionado ao classe ItemMenu, e dentro de uma
          linha (row) exibimos os dados.
           */
          PopupMenuButton<ItemMenu>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((ItemMenu item) {
                  return PopupMenuItem<ItemMenu>(
                      value: item,
                      child: Row(
                        children: [
                          item.icon,
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(item.nome),
                          ),
                        ],
                      ));
                }).toList();
              })
        ],
      ),
      body: TabBarView(
        controller: _trabController,
        children: <Widget>[
          AbaConversas(),
          AbaContatos(),
        ],
      ),
    );
  }
}
