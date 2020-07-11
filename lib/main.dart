import 'package:Homework_Communities/models/user.dart';
import 'package:Homework_Communities/services/auth_service.dart';
import 'package:Homework_Communities/shared/common.dart';
import 'package:Homework_Communities/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Homework Communities',
        theme: ThemeData(
          primarySwatch: primarySwaches,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}
