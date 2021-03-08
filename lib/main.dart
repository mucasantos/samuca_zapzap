import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samuca_zapzap/login.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xffE07A5F),
      accentColor: Color(0xffF4F1DE),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
