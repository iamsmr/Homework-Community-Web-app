import 'package:Homework_Communities/models/task.dart';
import 'package:Homework_Communities/screens/home.dart/body.dart';
import 'package:Homework_Communities/services/auth_service.dart';
import 'package:Homework_Communities/services/database_services.dart';
import 'package:Homework_Communities/shared/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final String uid;
  Home({this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '  ';
  DatabaseService _databaseService = DatabaseService();
  void getUserInfo() async {
    await _databaseService.getUserInfo(widget.uid);
    setState(() {
      name = _databaseService.name;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Task>>.value(
      value: DatabaseService().task,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            elevation: 0,
            title: logoText,
            actions: [
              IconButton(
                tooltip: '$name',
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    name.substring(0, 1),
                    style: TextStyle(fontSize: 25, color: primarySwaches),
                  ),
                ),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Log out',
                icon: Icon(Icons.exit_to_app),
                onPressed: () => AuthService().signOut(),
              )
            ],
          ),
        ),
        body: Body(uid: widget.uid),
      ),
    );
  }
}
