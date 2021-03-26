import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samuca_zapzap/util/appsettings.dart';
import 'package:samuca_zapzap/util/colors.dart';

class Configurations extends StatefulWidget {
  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();

  File _image;
  bool _uploadingImage = false;
  Firestore db = Firestore.instance;

  Future _recoverImage(String origem) async {
    File imageSelecionada;
    switch (origem) {
      case 'camera':
        imageSelecionada =
            await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case 'galeria':
        imageSelecionada =
            await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _uploadingImage = true;
      _image = imageSelecionada;
      if (_image != null) {
        _uploadImage();
      }
      _uploadingImage = false;
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    StorageReference pastaRaiz = storage.ref();

    StorageReference arquivo =
        pastaRaiz.child('perfil').child(AppSettings.userId + ".jpg");

    //Upload Imagem
    StorageUploadTask task = arquivo.putFile(_image);

    //Controlar o progresso

    task.events.listen((event) {
      if (event.type == StorageTaskEventType.progress) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (event.type == StorageTaskEventType.success) {
        setState(() {
          _uploadingImage = false;
        });
      }
    });

    //recuperar url da imagem

    task.onComplete.then((value) => _recoverUrlImage(value));
  }

  Future _recoverUrlImage(StorageTaskSnapshot url) async {
    String myUrl = await url.ref.getDownloadURL();

    setState(() {
      AppSettings.myProfileImage = myUrl;
    });
    _atualizarUrlImageFirestore(myUrl);
  }

  _atualizarUrlImageFirestore(String url) async {
    Map<String, dynamic> data = {'urlImage': url};

    db.collection('usuarios').document(AppSettings.userId).updateData(data);
  }

  _atualizarNome() async {
    Map<String, dynamic> data = {'nome': _controllerNome.text};

    AppSettings.usuarioAtual = _controllerNome.text;

    db.collection('usuarios').document(AppSettings.userId).updateData(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerNome.text = AppSettings.usuarioAtual;
    _controllerEmail.text = AppSettings.myEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Perfil'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: _uploadingImage
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        )
                      : Container(),
                ),
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: AppSettings.myProfileImage != ''
                      ? NetworkImage(AppSettings.myProfileImage)
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          _recoverImage('camera');
                        },
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: kColorFundo,
                        )),
                    FlatButton(
                        onPressed: () {
                          _recoverImage('galeria');
                        },
                        child: Icon(
                          Icons.image,
                          color: kColorFundo,
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: false,
                    keyboardType: TextInputType.text,
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
                    enabled: false,
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: kColorBotao,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    onPressed: _atualizarNome,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
