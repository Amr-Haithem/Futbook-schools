import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:provider/provider.dart';
import 'Slots.dart';

class SingleButtonBlock extends StatefulWidget {
  final sequentialIndex;
  final String slotMeaning;
  final int scale;
  final List slots;
  final String name;
  final String phoneNumber;
  final bool Reserved;
  final bool Arrived;

  const SingleButtonBlock(
      {this.sequentialIndex,
      this.slotMeaning,
      this.scale,
      this.slots,
      this.name,
      this.phoneNumber,
      this.Reserved,
      this.Arrived});

  @override
  _SingleButtonBlockState createState() => _SingleButtonBlockState();
}

class _SingleButtonBlockState extends State<SingleButtonBlock> {
  //not selected in first
  bool selected = false;
  RealTimeDBService rt = RealTimeDBService();
  Color backgroundColorSwitch = Colors.greenAccent[400];
  static ValueNotifier<List> enteredValue = ValueNotifier([]);

  @override
  void initState() {
    enteredValue.value = [];
    Slots.arr = [];
    super.initState();
  }

  //this function will return a check box if reserved

  Color buttonColorSwitch(newVal) {
    for (int i = 0; i < newVal.length; i++) {
      if (widget.sequentialIndex == newVal[i]) {
        return Colors.yellowAccent[400];
      }
    }
    return Colors.greenAccent[400];
  }

  @override
  Widget build(BuildContext context) {
    var providerHolder = context.watch<ProvidersModel>();
    print(providerHolder.slotsOfThisReservationToConfirmArrival);

    Widget checkIfReservedToGetCheckBox() {
      if (widget.Arrived) {
        return Checkbox(value: true);
      } else if (widget.Reserved) {
        bool starter = false;
        if (context
            .read<ProvidersModel>()
            .slotsOfThisReservationToConfirmArrival
            .contains(widget.slots)) {
          starter = true;
          return Checkbox(
              value: starter,
              onChanged: (bool value) {
                setState(() {
                  providerHolder.slotsOfThisReservationToConfirmArrival
                      .remove(widget.slots);
                });
                print(context
                    .read<ProvidersModel>()
                    .slotsOfThisReservationToConfirmArrival);
              });
        } else {
          return Checkbox(
              value: starter,
              onChanged: (bool value) {
                setState(() {
                  print(widget.slots);
                  providerHolder.slotsOfThisReservationToConfirmArrival
                      .add(widget.slots);
                  value = !value;
                  print(context
                      .read<ProvidersModel>()
                      .slotsOfThisReservationToConfirmArrival);
                });
              });
        }
      } else
        return Container();
    }

    Slots.arr = [];

    return Container(
      // margin:
      //     const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 5.0, right: 5.0),
      child: ValueListenableBuilder(
        valueListenable: enteredValue,
        builder: (context, newVal, child) {
          for (int i = 0; i < newVal.length; i++) {
            if (widget.sequentialIndex == newVal[i]) {
              Slots.arr.add(widget.slots);
              print(Slots.arr);
              break;
            }
          }
          return ElevatedButton(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.center,
                  children: nameAndPhoneShower(
                      widget.name, widget.phoneNumber, widget.slotMeaning),
                ),
                checkIfReservedToGetCheckBox(),
              ],
            ),
            onPressed: () {
              Slots.arr = [];
              if (enteredValue.value.isEmpty) {
                enteredValue.value = [widget.sequentialIndex];
              } else {
                if (widget.sequentialIndex < enteredValue.value[0]) {
                  enteredValue.value = [enteredValue.value[0]];
                } else if (widget.sequentialIndex == enteredValue.value[0]) {
                  enteredValue.value = [];
                } else {
                  int difference =
                      widget.sequentialIndex - enteredValue.value[0];
                  if (difference < 3) {
                    List temp = enteredValue.value;
                    enteredValue.value = [];
                    for (int i = temp[0]; i < temp[0] + difference + 1; i++) {
                      enteredValue.value.add(i);
                    }
                  } else {
                    List temp = enteredValue.value;
                    enteredValue.value = [];
                    for (int i = temp[0]; i < temp[0] + 3; i++) {
                      enteredValue.value.add(i);
                    }
                  }
                }
              }
              print(enteredValue.value);
            },
            style: ElevatedButton.styleFrom(
              primary: buttonColorSwitch(newVal),
              minimumSize: Size(328.0, 80.0 * widget.scale),
            ),
          );
        },
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
