import 'package:Homework_Communities/services/auth_service.dart';
import 'package:Homework_Communities/shared/common.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogleScreen;
  Register(this.toogleScreen);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String error = '';
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  String email;
  String password;
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          side,
          Expanded(
            flex: 2,
            child: Container(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (val) => val.isEmpty && val.length < 3
                              ? 'Enter a valid username'
                              : null,
                          onChanged: (val) => setState(() => username = val),
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (val) => RegExp(pattern).hasMatch(val)
                              ? null
                              : 'Please enter a valid email',
                          onChanged: (val) => setState(() => email = val),
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'Enter password with 6+ char'
                              : null,
                          onChanged: (val) => setState(() => password = val),
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 42,
                        width: 300,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              //execuite
                              await _authService.cteateUserwithEmailAndPassword(
                                email,
                                password,
                                username,
                              );
                              setState(() {
                                error = _authService.error;
                              });
                            }
                          },
                          child: Text('Register'),
                          textColor: Colors.white,
                          color: primarySwaches,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: FlatButton(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () => widget.toogleScreen(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Have an acount ?'),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: primarySwaches,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      error == ''
                          ? Container()
                          : Container(
                              width: 500,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              color: Colors.amberAccent,
                              child: ListTile(
                                leading: Icon(Icons.error, size: 40),
                                title: Text(error ??
                                    'Something went wrong please Reload'),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      error = '';
                                    });
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
