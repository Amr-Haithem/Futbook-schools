import 'package:flutter/material.dart';
import 'package:futbook_school/Services/auth.dart';

class SignIn extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final Function ToggleAuthScreens;

  // ignore: non_constant_identifier_names
  SignIn({this.ToggleAuthScreens});

  @override
  _SignInState createState() => _SignInState();
}

final AuthService _auth = AuthService();
String email = '';
String password = '';

class _SignInState extends State<SignIn> {
  final authenticationInstance = new AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          elevation: 1.0,
          title: Text('sign in please'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  widget.ToggleAuthScreens();
                },
                icon: Icon(Icons.person),
                label: Text('Register'))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(validator: (value) {
                    if (value.isEmpty) {
                      return 'plz enter email ';
                    }
                    return null;
                  }, onChanged: (val) {
                    setState(() => email = val);
                  }),
                  SizedBox(height: 20.0),
                  TextFormField(
                      validator: (value) {
                        if (value.length < 6 || value.isEmpty) {
                          return 'password has to be more than 6 characters ';
                        }
                        return null;
                      },
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      }),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        authenticationInstance.signInWithEmailAndPass(
                            email, password);
                      }
                    },
                  )
                ],
              )),
        ));
  }
}
