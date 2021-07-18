import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Pages/Screens/Fields/SingleFieldBlock.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';

class Fields extends StatefulWidget {
  final User user;

  const Fields({this.user});

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,


      child: Wrap(

        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        spacing: 10.0,
        runSpacing: 20.0,
        children: List<SingleFieldBlock>.generate(
          //number of fields in database
          4,
          (int index)=>  SingleFieldBlock(indexOfFieldBlock: index ,user:widget.user)
        ),
        ),
      );
  }
}
