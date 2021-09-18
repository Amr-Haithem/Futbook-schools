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
import "package:charcode/ascii.dart";

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
    '2-3 AM',
    '4-5 AM',
    '6-7 AM',
    '7-8 AM',
  ];

  //static List;
  static List arr = [];

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  int shifterHelper;

//this function will extract me each length of the data begotten from the db

  int scaleFunctions(int i, List listOfAllData) {
    if (i == 0) {
      shifterHelper = 0;
    }

    if (listOfAllData != null &&
        i < listOfAllData.length &&
        i + shifterHelper == listOfAllData[i]['slots'][0]) {
      shifterHelper += listOfAllData[i]['slots'].length - 1;
      return listOfAllData[i]['slots'].length;
    } else {
      return 1;
    }
  }

  //the following function returns 'a' for example after a number bigger than 9
  List listProviderForNumbersBiggerThan9(int theNumber) {
    List<String> chars = ["a", "b", "c", "d", "e", "f", "g", "h"];
    if (theNumber > 9) {
      return [chars[theNumber - 10] + theNumber.toString()];
    } else {
      return [theNumber];
    }
  }

  String slotsMeaningGiver(List x) {
    String y = '';
    String s = '';
    // String s = widget.SlotsMeaning[x[0]].substring(0, '-');
    //print(s);
    bool switcher = false;
    for (int i = 0; widget.SlotsMeaning[x[0]][i] != '-'; i++) {
      s += widget.SlotsMeaning[x[0]][i];
    }
    for (int i = 0; i < widget.SlotsMeaning[x[x.length - 1]].length; i++) {
      if (widget.SlotsMeaning[x[x.length - 1]][i] == '-') {
        switcher = true;
      }
      if (switcher) {
        y += widget.SlotsMeaning[x[x.length - 1]][i];
      }
    }
    return s + y;
  }

  List<SingleButtonBlock> ListOfBlocksBuilder(List listOfAllData) {
    int sequentialIndex=0;
    int counter = 0;
    List<SingleButtonBlock> listOfBlocks = [];
    for (int i = 0; i < 16; i++) {
      if (listOfAllData != null &&
          counter < listOfAllData.length &&
          i == listOfAllData[counter]['slots'][0]) {
        i += listOfAllData[counter]['slots'].length - 1;

        listOfBlocks.add(SingleButtonBlock(
          sequentialIndex: sequentialIndex,
          slotMeaning: slotsMeaningGiver(listOfAllData[counter]['slots']),
          scale: listOfAllData[counter]['slots'].length,
          slots: listOfAllData[counter]['slots'],
          name: listOfAllData[counter]['nameOfCustomer'],
          phoneNumber: listOfAllData[counter]['phoneNumberOfCustomer'],
          Reserved: true,
        ));
        counter++;
        sequentialIndex++;
      } else {
        listOfBlocks.add(SingleButtonBlock(
          sequentialIndex: sequentialIndex,
            slotMeaning: widget.SlotsMeaning[i],
            scale: 1,
            slots: listProviderForNumbersBiggerThan9(i),
            Reserved: false));
        sequentialIndex++;
      }
    }
    return listOfBlocks;
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
              StreamBuilder(
                  initialData: null,
                  stream: RealTimeDBService().streamValueOfUserData(0),
                  builder: (context, snapshot) {
                    List listOfAllData;
                    int numberOfSlotsRemoved = 0;
                    if (snapshot.hasData) {
                      print('Stream changed');
                      Map allData = snapshot.data.snapshot.value;

                      if (allData != null) {
                        listOfAllData = allData.values.toList();
                        print(listOfAllData);

                      }
                    }
                    return Container(
                        //color: Colors.blueGrey,
                        height: 500,
                        width: 1000,
                        child: Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          direction: Axis.vertical,
                          children: ListOfBlocksBuilder(listOfAllData),
                        ));
                  })
            ]));
  }
}
