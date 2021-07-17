import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Pages/Screens/Fields/SingleFieldDataForSlots.dart';
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
        primary: Colors.blueGrey,
        minimumSize: Size(500.0, 300.0),
      ),
      onPressed: (){
      Navigator.pushNamed(context, '/Slots',arguments: SingleFieldDataForSlots(user:widget.user,indexOfThisField: widget.indexOfFieldBlock));
    },child: Text("field "+widget.indexOfFieldBlock.toString()+""),);
  }
}