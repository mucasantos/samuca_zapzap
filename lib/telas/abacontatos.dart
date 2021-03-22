import 'package:flutter/material.dart';
import 'package:samuca_zapzap/model/conversa.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  List<Conversa> listaConversas = [
    Conversa('001', 'Maria Clara', 'Olá, tudo bem?',
        'https://firebasestorage.googleapis.com/v0/b/myuber-39969.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=cea573e8-ab16-4531-9c6b-5e4d09f54eb5'),
    Conversa('002', 'Samuel Santos', 'Olá, tudo bem?',
        'https://firebasestorage.googleapis.com/v0/b/myuber-39969.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=fc2a0a86-40bf-484f-9c9f-b01937380544'),
    Conversa('003', 'Ana Maria', 'Olá, tudo bem?',
        'https://firebasestorage.googleapis.com/v0/b/myuber-39969.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=517fe61c-7e6c-496b-9605-d04f7c332b91'),
    Conversa('004', 'Renato Silva', 'Olá, tudo bem?',
        'https://firebasestorage.googleapis.com/v0/b/myuber-39969.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=ff91e3ff-ac9a-4bb6-9ef0-52f1cbd42428'),
    Conversa('005', 'Jamilton Damasceno', 'Olá, tudo bem?',
        'https://firebasestorage.googleapis.com/v0/b/myuber-39969.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=ce9da16e-ca1f-44d2-b723-0420f570fc9a'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: listaConversas.length,
          itemBuilder: (context, index) {
            Conversa conversa = listaConversas[index];

            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(conversa.cominhoImagem),
              ),
              title: Text(
                conversa.nome,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

            );
          }),
    );
  }
}
