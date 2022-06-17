import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:provider/provider.dart';

class SingleButtonBlock extends StatefulWidget {
  final sequentialIndex;
  final String? slotMeaning;
  final int? scale;
  final List? slots;
  final String? name;
  final String? phoneNumber;
  final bool? reserved;
  final bool? arrived;
  final String? day;
  final int? field;
  final User? user;
  final num? reservationCost;
  final bool? userApp;
  final String? dayIndex;

  const SingleButtonBlock(
      {this.sequentialIndex,
      this.slotMeaning,
      this.scale,
      this.slots,
      this.name,
      this.phoneNumber,
      this.reserved,
      this.arrived,
      this.day,
      this.dayIndex,
      this.field,
      this.user,
      this.reservationCost,
      this.userApp});

  @override
  _SingleButtonBlockState createState() => _SingleButtonBlockState();
}

class _SingleButtonBlockState extends State<SingleButtonBlock> {
  bool selected = false;
  RealTimeDBService rt = RealTimeDBService();
  Color? backgroundColorSwitch = Colors.greenAccent[400];
  static ValueNotifier<List> enteredValue = ValueNotifier([]);
  set setEnteredValue(List x) {
    enteredValue.value = x;
  }

  @override
  void initState() {
    enteredValue.value = [];
    context.read<ProvidersModel>().slotsToBeReserved = [];
    super.initState();
  }

  //this function will return a check box if reserved

  Color? buttonColorSwitch(newVal) {
    if (widget.arrived!) {
      return Colors.grey[600];
    } else if (widget.reserved!) {
      return Colors.grey[400];
    }
    for (int i = 0; i < newVal.length; i++) {
      if (widget.sequentialIndex == newVal[i]) {
        return Colors.yellowAccent;
      }
    }

    return Colors.lightGreenAccent[400];
  }

  Widget ifArrivedPutCashSignAndLock() {
    if (widget.arrived!) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MaterialButton(
            onPressed: () {},
            color: Colors.grey[800],
            textColor: Colors.grey[350],
            child: Icon(
              Icons.attach_money_rounded,
              size: 20,
            ),
            shape: CircleBorder(),
          ),
          MaterialButton(
            onPressed: () {},
            color: Colors.grey[800],
            textColor: Colors.grey[350],
            child: Icon(
              Icons.lock,
              size: 20,
            ),
            shape: CircleBorder(),
          )
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget checkboxIfSelected(newVal) {
    for (int i = 0; i < newVal.length; i++) {
      if (widget.sequentialIndex == newVal[i]) {
        // ignore: missing_required_param
        return const Checkbox(
          value: true,
        );
      }
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProvidersModel>().slotsToBeReserved = [];

    return Container(
      child: ValueListenableBuilder(
        valueListenable: enteredValue,
        builder: (context, dynamic newVal, child) {
          if (newVal.contains(widget.sequentialIndex) && widget.reserved!) {
            //here i used this to trim if there's a reserved slot in the way
            newVal.removeRange(widget.sequentialIndex - 1, newVal.length);
          }

          if (newVal.contains(widget.sequentialIndex)) {
            print(widget.reserved);
            context
                .read<ProvidersModel>()
                .slotsToBeReserved
                .add(widget.slots![0]);
            print(context.read<ProvidersModel>().slotsToBeReserved);
          }

          return ElevatedButton(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: nameAndPhoneShower(widget.name, widget.slotMeaning!),
                ),
                ifArrivedPutCashSignAndLock(),
                checkboxIfSelected(newVal)
              ],
            ),
            onPressed: () {
              if (widget.reserved!) {
                Navigator.pushNamed(context, '/Invoice',
                    arguments: DataWithNameAndPhoneNumber(
                        arrived: widget.arrived!,
                        nameOfCustomer: widget.name!,
                        phoneNumber: widget.phoneNumber!,
                        indexOfThisField: widget.field!,
                        slotsMeaning: widget.slotMeaning!,
                        dayIndex:widget.dayIndex!,
                        slots: widget.slots!,
                        day: widget.day!,
                        user: widget.user!,
                        reservationCost: widget.reservationCost!,
                        userApp: widget.userApp!));
              } else {
                context.read<ProvidersModel>().slotsToBeReserved = [];
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
              }
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: 1, color: Colors.black),
              primary: buttonColorSwitch(newVal),
              minimumSize: Size(328.0, 80.0 * widget.scale!),
            ),
          );
        },
      ),
    );
  }

  List<Text> nameAndPhoneShower(String? x, String z) {
    List<Text> textList = [];

    if (x != null) {
      textList.add(Text(
        x,
        style: TextStyle(
            color: widget.arrived! ? Colors.white : Colors.grey[900],
            fontFamily: "Cairo",
            fontSize: 24),
      ));
    }
    textList.add(Text(
      z,
      style: TextStyle(
          color: widget.arrived! ? Colors.white : Colors.grey[900],
          fontFamily: "Cairo",
          fontSize: 24),
    ));
    return textList;
  }
}
