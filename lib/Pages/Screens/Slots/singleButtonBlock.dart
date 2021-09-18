import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';

import 'Slots.dart';

class SingleButtonBlock extends StatefulWidget {
  final sequentialIndex;
  final String slotMeaning;
  final int scale;
  final List slots;
  final String name;
  final String phoneNumber;
  final bool Reserved;

  const SingleButtonBlock(
      {this.sequentialIndex,
      this.slotMeaning,
      this.scale,
      this.slots,
      this.name,
      this.phoneNumber,
      this.Reserved});

  @override
  _SingleButtonBlockState createState() => _SingleButtonBlockState();
}

class _SingleButtonBlockState extends State<SingleButtonBlock> {
  static ValueNotifier<List> enteredValue = ValueNotifier([]);

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

        child:ValueListenableBuilder(
            valueListenable: enteredValue,
            builder: (context, newVal, child) {
              for(int i = 0;i<newVal.length;i++){
                if(widget.sequentialIndex==newVal[i]){
                  print(widget.sequentialIndex);
                }
              }
              return Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                children: nameAndPhoneShower(
                    widget.name, widget.phoneNumber, widget.slotMeaning),
              );
            }) ,
        onPressed: () {

          if (!selected) {
            enteredValue.value.add(widget.sequentialIndex);


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
          minimumSize: Size(328.0, 68.0 * widget.scale),
        ),
      ),
    );
  }

  List<Text> nameAndPhoneShower(String x, String y, String z) {
    List<Text> textList = [];

    if (x != null && y != null) {
      textList.add(Text(
        x,
        style: TextStyle(
            color: Colors.grey[900], fontFamily: "Cairo", fontSize: 24),
      ));
      textList.add(Text(
        y,
        style: TextStyle(
            color: Colors.grey[900], fontFamily: "Cairo", fontSize: 24),
      ));
    }
    textList.add(Text(
      z,
      style:
          TextStyle(color: Colors.grey[900], fontFamily: "Cairo", fontSize: 24),
    ));
    return textList;
  }
}
