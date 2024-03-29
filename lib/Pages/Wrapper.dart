import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:futbook_school/Pages/Screens/Authenticate/SignIn.dart';
import 'package:futbook_school/Pages/Screens/Fields/Fields.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return SignIn();
    }
    else{
      return Fields(user:user);
    }
  }
}
