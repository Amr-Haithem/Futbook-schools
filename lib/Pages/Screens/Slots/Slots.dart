import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';
import 'package:futbook_school/Pages/Screens/Slots/singleButtonBlock.dart';
import 'package:futbook_school/Services/FirestoreService.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:futbook_school/Services/auth.dart';

class Slots extends StatefulWidget {
  static List arr = [];

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _auth = AuthService();
  final rt = RealTimeDBService();
  DataOfUserAndFieldIndexOnly args;

  @override
  void initState() {
    super.initState();
    //ahmed sameh (is it a good practice?)
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute
            .of(context)
            .settings
            .arguments;
      });
      rt.listenToThisPageSlots(args.user, args.indexOfThisField);

    });
  }
  @override
  Widget build(BuildContext context) {
    Slots.arr = [];
    print("emptied slots array");
    //TODO to ensure null-safety put an ! after (context)

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Slots page'),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          textStyle: TextStyle(
                            fontSize: 40,
                          )),
                      child: Text("Reserve"),
                      onPressed: () async {
                        if (await rt.updateReservationData(
                            args.user, args.indexOfThisField, Slots.arr)) {
                          Navigator.pushNamed(context, '/CustomerInfo',
                              arguments: DataWithoutNameAndPhoneNumber(
                                  user: args.user,
                                  indexOfThisField: args.indexOfThisField,
                                  slotsReserved: Slots.arr));
                        } else {
                          print("didn't register : a message from slots page");
                        }
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          textStyle: TextStyle(
                            fontSize: 40,
                          )),
                      child: Text("Un Reserve"),
                      onPressed: () async {
                        await rt.unReserveSlots(
                            args.user, args.indexOfThisField, Slots.arr);
                        Slots.arr = [];
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    spacing: 10.0,
                    runSpacing: 20.0,
                    children: [
                      SingleButtonBlock(slot: '8-9 AM', associatedIndex: 0),
                      SingleButtonBlock(slot: '9-10 AM', associatedIndex: 1),
                      SingleButtonBlock(slot: '10-11 AM', associatedIndex: 2),
                      SingleButtonBlock(slot: '11-12 AM', associatedIndex: 3),
                      SingleButtonBlock(slot: '12-1 PM', associatedIndex: 4),
                      SingleButtonBlock(slot: '1-2 PM', associatedIndex: 5),
                      SingleButtonBlock(slot: '2-3 PM', associatedIndex: 6),
                      SingleButtonBlock(slot: '3-4 PM', associatedIndex: 7),
                      SingleButtonBlock(slot: '4-5 PM', associatedIndex: 8),
                      SingleButtonBlock(slot: '5-6 PM', associatedIndex: 9),
                      SingleButtonBlock(slot: '6-8 PM', associatedIndex: 10),
                      SingleButtonBlock(slot: '8-9 PM', associatedIndex: 11),
                      SingleButtonBlock(slot: '9-10 PM', associatedIndex: 12),
                      SingleButtonBlock(slot: '10-11 PM', associatedIndex: 13),
                      SingleButtonBlock(slot: '12-1 AM', associatedIndex: 14),
                    ]),
              ),
            ]));
  }
}
