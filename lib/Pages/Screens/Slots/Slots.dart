import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';
import 'package:futbook_school/Models/RerservationHolder.dart';
import 'package:futbook_school/Pages/Screens/Slots/singleButtonBlock.dart';
import 'package:futbook_school/Services/FirestoreService.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:futbook_school/Services/auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Slots extends StatefulWidget {
  List SlotsMeaning = [
    '8-9 AM',
    '9-10 AM',
    '10-11 AM',
    '11-12 AM',
    '12-1 PM',
    '1-2 PM',
    '2-3 PM',
    '3-4 PM',
    '4-5 PM',
    '5-6 PM',
    '6-8 PM',
    '8-9 PM',
    '9-10 PM',
    '10-11 PM',
    '12-1 AM',
    '1-2 AM',
  ];

  //static List;
  static List arr = [];

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  int shifterHelper;

//this function will extract me each in
  int scaleFunctions(int i, List listOfAllData) {
    if (i == 0) {
      shifterHelper = 0;
    }

    if (listOfAllData != null &&
        i < listOfAllData.length &&
        i + shifterHelper == listOfAllData[i]['slots'][0]) {
      shifterHelper += listOfAllData[i]['slots'].length - 1;
      //print(listOfAllData[i]['slots'].length.toString() + "hello");
      return listOfAllData[i]['slots'].length;
    } else {
      // print(1);
      return 1;
    }
  }

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
        args = ModalRoute.of(context).settings.arguments;
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
                          //here we stop the listener

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
              StreamBuilder(
                initialData: null,
                stream: RealTimeDBService().streamValueOfUserData(0),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('Stream changed');
                    print(RealTimeDBService().dataReservation);
                    Map allData = snapshot.data.snapshot.value;
                    int numberOfSlotsRemoved = 0;
                    List listOfAllData;
                    if (allData != null) {
                      listOfAllData = allData.values.toList();
                      allData.forEach((key, value) {
                        numberOfSlotsRemoved += value["slots"].length - 1;
                      });
                    }
                    int shifterAmigo = 0;

                    return Container(
                      height: 500,
                      child: StaggeredGridView.countBuilder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: 50, horizontal: 65),
                          scrollDirection: Axis.horizontal,
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                              1 * scaleFunctions(index, listOfAllData), 2.8),
                          crossAxisCount: 5,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          itemCount: 16 - numberOfSlotsRemoved,
                          itemBuilder: (ctx, index) {
                            if (listOfAllData != null &&
                                index < listOfAllData.length &&
                                index + shifterAmigo ==
                                    listOfAllData[index]['slots'][0]) {
                              shifterAmigo +=
                                  listOfAllData[index]['slots'].length - 1;

                              return SingleButtonBlock(
                                slot: widget.SlotsMeaning[index],
                                associatedIndex: index,
                                scale: listOfAllData[index]['slots'].length,
                                slots: listOfAllData[index]['slots'],
                                name: listOfAllData[index]['nameOfCustomer'],
                                phoneNumber: listOfAllData[index]
                                    ['phoneNumberOfCustomer'],
                              );
                            } else {
                              return SingleButtonBlock(
                                slot: widget.SlotsMeaning[index],
                                associatedIndex: index,
                                scale: 1,
                                slots: [0],
                              );
                            }
                          }),
                    );
                  }
                  return Text("data");
                },
              ),
            ]));
  }
}
