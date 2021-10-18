import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Pages/Screens/Fields/SingleFieldBlock.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';
import 'package:futbook_school/Services/FirestoreService.dart';

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
    return StreamBuilder<Object>(
        stream: _firestoreService.listenToDataFromSchoolList('schoolId'),
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/Assets/Images/pitch_1.png"),
                fit: BoxFit.cover,
              ),
            ),
            //color: Colors.white,

            child: FutureBuilder(
              future: _firestoreService.getNumberOfFieldsFunc('x'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      spacing: 30.0,
                      runSpacing: 30.0,
                      children: List<SingleFieldBlock>.generate(
                          snapshot.data,
                          (int index) => SingleFieldBlock(
                              indexOfFieldBlock: index, user: widget.user)),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          );
        });
  }
}
