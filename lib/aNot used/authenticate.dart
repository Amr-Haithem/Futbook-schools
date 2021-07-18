import 'package:flutter/cupertino.dart';
import 'package:futbook_school/aNot%20used/Register.dart';
import 'package:futbook_school/Pages/Screens/Authenticate/SignIn.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}
class _AuthenticateState extends State<Authenticate> {

  bool showSignIn= true;
  void ToggleAuthScreens(){
    setState(()=>showSignIn=!showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(ToggleAuthScreens:ToggleAuthScreens);
    }else{
      return Register(ToggleAuthScreens:ToggleAuthScreens);
    }
  }
}
