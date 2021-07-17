import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Pages/Screens/Fields/Fields.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';
import 'package:provider/provider.dart';
import 'Pages/Wrapper.dart';
import 'Services/auth.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:AuthService().user,
        child: MaterialApp(
       home:Wrapper(),
          routes: {
            '/Slots': (context) => Slots(),

          },
    ));
  }
}
/*
*
    initialRoute: '/',
    routes: {
      '/': (context) => SignInPage(),
      //'/Slots': (context) => Slots(),
      //'/verifyPayment': (context) => verifyPayment()
    },

*
* */