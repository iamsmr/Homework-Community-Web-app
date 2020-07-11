import 'package:Homework_Communities/models/user.dart';
import 'package:Homework_Communities/screens/auth/authenticate.dart';
import 'package:Homework_Communities/screens/home.dart/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home(uid: user.uid);
    }
  }
}
