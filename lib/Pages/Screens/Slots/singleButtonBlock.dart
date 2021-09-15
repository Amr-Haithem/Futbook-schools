import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';

import 'Slots.dart';

class SingleButtonBlock extends StatefulWidget {
  final String slot;
  final int scale;
  final List slots;
  final String name;
  final String phoneNumber;
  final bool Reserved;

  const SingleButtonBlock(
      {this.slot,
      this.scale,
      this.slots,
      this.name,
      this.phoneNumber,
      this.Reserved});

  @override
  _SingleButtonBlockState createState() => _SingleButtonBlockState();
}

class _SingleButtonBlockState extends State<SingleButtonBlock> {
  //not selected in first
  bool selected = false;
  RealTimeDBService rt = RealTimeDBService();
  Color backgroundColorSwitch = Colors.greenAccent[400];

  @override
  void initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin:
      //     const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
      child: ElevatedButton(
        child: Text(
          putNameIfReserved(widget.name, widget.phoneNumber),
          style: TextStyle(
              color: Colors.grey[900], fontFamily: "Cairo", fontSize: 32),
        ),
        onPressed: () {
          if (!selected) {
            Slots.arr.add(widget.slots);
            selected = !selected;
            setState(() {
              backgroundColorSwitch = Colors.yellowAccent;
            });
            print(Slots.arr);
          } else {
            Slots.arr.remove(widget.slots);

            selected = !selected;
            setState(() {
              backgroundColorSwitch = Colors.greenAccent[400];
            });
            print(Slots.arr);
          }
        },
        style: ElevatedButton.styleFrom(
          primary: backgroundColorSwitch,
          minimumSize: Size(280.0, 58.0 * widget.scale),
        ),
      ),
    );
  }

  String putNameIfReserved(String name, String phoneNumber) {
    if (name != null && phoneNumber != null) {
      return name + phoneNumber;
    } else {
      return '';
    }
  }
}
