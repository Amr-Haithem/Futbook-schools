import 'package:flutter/material.dart';
import 'package:futbook_school/Services/auth.dart';


class Register extends StatefulWidget {

  final Function ToggleAuthScreens;

   Register({this.ToggleAuthScreens});
  @override
  _RegisterState createState() => _RegisterState();
}

final AuthService _auth = AuthService();
String email = '';
String password='';


class _RegisterState extends State<Register> {
  final authenticationInstance= new AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green[800],
            elevation: 1.0,
            title:Text(
                'Register please'
            ),
            actions: <Widget>[
              FlatButton.icon(onPressed: (){widget.ToggleAuthScreens();}, icon: Icon(Icons.person), label: Text('Sign in'))
          ],
        ),
        body:Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
              child :Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height:20.0),
                    TextFormField(
                      validator: (value){
                        if(value.isEmpty){
                          return 'plz enter email ';
                        }
                        return null;
                      },
                        onChanged:(val){
                          setState(()=>email=val);
                        }
                    ),
                    SizedBox(height:20.0),
                    TextFormField(
                        obscureText: true,
                        validator: (value){
                          if(value.length<6 || value.isEmpty){
                            return 'password has to be more than 6 characters ';
                          }
                          return null;
                        },
                        onChanged:(val){
                          setState(()=>password=val);
                        }

                    ),
                    SizedBox(height:20.0),
                    ElevatedButton(
                      child:Text('Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: ()async {
                        if(_formKey.currentState.validate()) {
                          authenticationInstance.register(email, password);
                        }
                      },


                    )

                  ],
                ),
              )

          ),
        ));
  }
}
