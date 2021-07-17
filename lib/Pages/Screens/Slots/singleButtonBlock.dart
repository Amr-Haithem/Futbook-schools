import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';

import 'Slots.dart';

class SingleButtonBlock extends StatefulWidget {
  final String slot;
  final int associatedIndex;

  const SingleButtonBlock({this.slot,  this.associatedIndex});

  @override
  _SingleButtonBlockState createState() => _SingleButtonBlockState();
}

class _SingleButtonBlockState extends State<SingleButtonBlock> {
  //not selected in first
  bool selected = false;
  RealTimeDBService rt= RealTimeDBService();
  @override
  Widget build(BuildContext context) {
    selected=false;
    return TextButton(
      child: Text(widget.slot,style: TextStyle(fontSize: 50),),
      onPressed: ()  {
        if(!selected){
           Slots.arr.add(widget.associatedIndex);
          selected=!selected;
          print(Slots.arr);
        }
        else{
          Slots.arr.remove(widget.associatedIndex);
          selected=!selected;
          print(Slots.arr);
        }

      },
      style: TextButton.styleFrom(
        primary: Colors.amber,
        minimumSize: Size(300.0, 200.0),
      ),
    );
  }
}
