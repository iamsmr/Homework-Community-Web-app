import 'package:Homework_Communities/screens/auth/login.dart';
import 'package:Homework_Communities/screens/auth/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool switchScren = false;
  void toogleScreen() => setState(() => switchScren = !switchScren);

  @override
  Widget build(BuildContext context) {
    if (switchScren == false) {
      return Login(toogleScreen);
    } else {
      return Register(toogleScreen);
    }
  }
}
