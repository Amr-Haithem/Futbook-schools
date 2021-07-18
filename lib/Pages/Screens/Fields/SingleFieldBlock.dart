import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';


class SingleFieldBlock extends StatefulWidget {
  final int indexOfFieldBlock;
  final User user;
  const SingleFieldBlock({ this.indexOfFieldBlock,this.user});


  @override
  _SingleFieldBlockState createState() => _SingleFieldBlockState();
}

class _SingleFieldBlockState extends State<SingleFieldBlock> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 50,
        ),
        primary: Colors.blueGrey,
        minimumSize: Size(500.0, 300.0),
      ),
      onPressed: (){
      Navigator.pushNamed(context, '/Slots',arguments: DataOfUserAndFieldIndexOnly(user:widget.user,indexOfThisField: widget.indexOfFieldBlock));
    },child: Text("field "+widget.indexOfFieldBlock.toString()+""),);
  }
}