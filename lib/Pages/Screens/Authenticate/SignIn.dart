import 'package:flutter/material.dart';
import 'package:futbook_school/Services/auth.dart';

class SignIn extends StatefulWidget {
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names

  @override
  _SignInState createState() => _SignInState();
}

final AuthService _auth = AuthService();
String email = '';
String password = '';

class _SignInState extends State<SignIn> {
  final authenticationInstance = new AuthService();
  final _formKey = GlobalKey<FormState>();
  bool errorExists = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Assets/Images/pitch_1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: height,
            child: Wrap(
              //mainAxisAlignment: MainAxisAlignment.start,
              alignment: WrapAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    height: height * .2,
                    width: width * .4,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Futbook",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Cairo",
                            fontSize: 45),
                      ),
                    )),
                Form(
                  key: _formKey,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 80.0, horizontal: 200.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                ':اسم المستخدم',
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 28,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.0),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 20,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.yellowAccent,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(
                                        fontFamily: "Cairo", fontSize: 20),
                                    hintTextDirection: TextDirection.rtl,
                                    hintText: 'ادخل اسم المستخدم'),
                                validator: (value) {
                                  return 'ادخل الايميل و الرقم المرور الصحيحين';
                                },
                                onChanged: (val) {
                                  setState(() => email = val);
                                }),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                ':كلمة المرور',
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 28,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                autofocus: true,
                                style: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 18,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.yellowAccent,
                                    ),
                                    hintTextDirection: TextDirection.rtl,
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: TextStyle(
                                        fontFamily: "Cairo", fontSize: 20),
                                    border: OutlineInputBorder(),
                                    hintText: 'ادخل كلمة المرور'),
                                validator: (value) {
                                  return 'ادخل الايميل و الرقم المرور الصحيحين';
                                },
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() => password = val);
                                }),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(160, 65),
                              primary: Colors.red, // background
                              onPrimary: Colors.yellow, // foreground
                            ),
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            onPressed: () async {
                              await authenticationInstance
                                  .signInWithEmailAndPass(email, password);

                              _formKey.currentState.validate();
                            },
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
