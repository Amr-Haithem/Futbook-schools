import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Pages/Screens/Fields/SingleFieldBlock.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';
import 'package:futbook_school/Services/FirestoreService.dart';
import 'package:futbook_school/Services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Fields extends StatefulWidget {
  final User user;

  const Fields({this.user});

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<Object>(
          stream: _firestoreService.listenToDataFromSchoolList(widget.user.email),
          builder: (context, snapshot) {
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/Assets/Images/pitch_1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              //color: Colors.white,

              child: FutureBuilder(
                future: Future.wait([
                  _firestoreService.getNumberOfFieldsFunc(widget.user.email),
                  _firestoreService.getSchoolRealName(widget.user.email)
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50)),
                            color: Colors.white.withOpacity(.9),
                          ),
                          width: width * .4,
                          height: height * .2,
                          child: Text(snapshot.data[1],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Cairo",
                                  fontSize: 33)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            spacing: 30.0,
                            runSpacing: 30.0,
                            children: List<SingleFieldBlock>.generate(
                                snapshot.data[0],
                                (int index) => SingleFieldBlock(
                                    indexOfFieldBlock: index,
                                    user: widget.user)),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                        alignment: Alignment.center,
                        child: SpinKitFoldingCube(
                          color: Colors.green,
                        ));
                  }
                },
              ),
            );
          }),
    );
  }
}
