import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samuca_zapzap/model/Usuario.dart';
import 'package:samuca_zapzap/model/conversa.dart';
import 'package:samuca_zapzap/util/appsettings.dart';
import 'package:samuca_zapzap/util/colors.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  Future<List<Usuario>> _recuperarContatos() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();

    List<Usuario> listaUsuarios = List();

    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;

      if (dados['email'] == AppSettings.myEmail) continue;

      Usuario usuario = Usuario.fromJson(dados);

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text('Carregando Contatos'),
                  CircularProgressIndicator(
                    backgroundColor: kColorFundo,
                  )
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<Usuario> listaItens = snapshot.data;
                  Usuario usuario = listaItens[index];

                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          (usuario.urlImage == null) || (usuario.urlImage == '')
                              ? null
                              : NetworkImage(usuario.urlImage),
                    ),
                    title: Text(
                      usuario.nome ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
            break;
        }
        return Container();
      },
    ));
  }
}

/*




 */
