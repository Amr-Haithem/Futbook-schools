import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Pages/Screens/Slots/singleButtonBlock.dart';
import 'package:futbook_school/Services/FirestoreService.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:futbook_school/Services/auth.dart';
import 'package:provider/provider.dart';

class Slots extends StatefulWidget {
  List SlotsMeaning = [
    '8 AM - 9 AM',
    '9 AM - 10 AM',
    '10 AM - 11 AM',
    '11 AM - 12 PM',
    '12 PM - 1 PM',
    '1 PM - 2 PM',
    '2 PM - 3 PM',
    '3 PM - 4 PM',
    '4 PM - 5 PM',
    '5 PM - 6 PM',
    '6 PM - 7 PM',
    '7 PM - 8 PM',
    '8 PM - 9 PM',
    '9 PM - 10 PM',
    '10 PM - 11 PM',
    '11 PM - 12 AM',
    '12 AM - 1 AM',
    '1 AM - 2 AM',
    '2 AM - 3 AM',
    '3 AM - 4 AM',
    '4 AM - 5 AM',
    '5 AM - 6 AM',
    '6 AM - 7 AM',
    '7 AM - 8 AM',
  ];

  //static List;

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  int shifterHelper;
  bool somethingSelected = false;

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

  Future<List<SingleButtonBlock>> ListOfBlocksBuilder(
      List listOfAllData) async {
    int startTime =
        await _firestoreService.getThisSchoolDataStartTime('schoolDocName');

    int endTime =
        await _firestoreService.getThisSchoolDataEndTime('schoolDocName');
    startTime -= 8;
    endTime -= 8;
    if (startTime < 0) {
      startTime += 24;
    }
    ;
    if (endTime < 0) {
      endTime += 24;
    }
    int sequentialIndex = 0;
    int counter = 0;
    List<SingleButtonBlock> listOfBlocks = [];
    for (int i = startTime; i < endTime; i++) {
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
          Arrived: listOfAllData[counter]['arrived'] == null ||
                  listOfAllData[counter]['arrived'] == false
              ? false
              : true,
          Day: daysArray[currentDayIndex],
          Field: args.indexOfThisField,
        ));
        counter++;
        sequentialIndex++;
      } else {
        listOfBlocks.add(SingleButtonBlock(
            sequentialIndex: sequentialIndex,
            slotMeaning: widget.SlotsMeaning[i],
            scale: 1,
            slots: listProviderForNumbersBiggerThan9(i),
            Reserved: false,
            Arrived: false));
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

  //code of the slider
  List daysArray = ["day0", "day1", "day2", "day3", "day4", "day5", "day6"];
  /*
  http resopncse gdedddn
  */
  int currentDayIndex = 0;
  int numberOfFields = 7;
  bool _isButton1Disabled = true;
  bool _isButton2Disabled = false;

  Function isBackButtonEnabled() {
    context.read<ProvidersModel>().slotsToBeReserved = [];
    if (_isButton1Disabled)
      return null;
    else
      return () {
        setState(() {
          if (currentDayIndex > 0) {
            currentDayIndex--;
            _isButton2Disabled = false;
          }
          if (currentDayIndex == 0) _isButton1Disabled = true;
        });
      };
  }

  Function isForwardButtonEnabled() {
    context.read<ProvidersModel>().slotsToBeReserved = [];
    if (_isButton2Disabled)
      return null;
    else
      return () {
        setState(() {
          if (currentDayIndex < numberOfFields) {
            currentDayIndex++;
            _isButton1Disabled = false;
          }
          if (currentDayIndex == numberOfFields) _isButton2Disabled = true;
        });
      };
  }

  static ValueNotifier<List> enteredValue = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    //context.watch<ProvidersModel>().slotsToBeReserved.toString();
    //Provider.of<ProvidersModel>(context, listen: true).slotsToBeReserved !=[]
    Widget backToFiledsOrCancelButton() {
      if (context.watch<ProvidersModel>().slotsToBeReserved != []) {
        print("hello");
        return SizedBox(
          width: 125,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red[700],
                textStyle: TextStyle(
                  fontSize: 35,
                )),
            child: Text("إلغاء"),
            onPressed: () async {},
          ),
        );
      } else {
        return MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
          textColor: Colors.black,
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            size: 27,
          ),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        );
      }
    }

    print("emptied slots array");
    //TODO to ensure null-safety put an ! after (context)

    return Scaffold(
        /*
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Slots page'),
        ),*/
        body: Container(
      color: Colors.grey[100],
      child: Wrap(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //chose between two button

              backToFiledsOrCancelButton(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (args.indexOfThisField + 1).toString() + ' ملعب',
                    style: TextStyle(fontFamily: "Cairo", fontSize: 42),
                  ),
                  Text('data',
                      style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //isForwardButtonEnabled()
                      Container(
                        width: 50,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey[700]),
                          onPressed: isBackButtonEnabled(),
                          child: IconButton(
                            color: Colors.grey,
                            icon: Transform.translate(
                              offset: Offset(-10, -4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        daysArray[currentDayIndex],
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 30),
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: 50,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey[700]),
                          onPressed: isForwardButtonEnabled(),
                          child: IconButton(
                            color: Colors.grey[800],
                            icon: Transform.translate(
                              offset: Offset(-10, -4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(children: [
                //choose between two buttons
                ReserveButton(
                    rt: rt,
                    args: args,
                    daysArray: daysArray,
                    currentDayIndex: currentDayIndex)
              ])
            ],
          ),
        ),

        /*SizedBox(
              height: 50,
            ),*/
        StreamBuilder(
          initialData: null,
          stream: _firestoreService.listenToDataFromSchoolList('schoolId'),
          builder: (context, snapshot1) {
            return StreamBuilder(
                //here we can use provider along with sliderOfDays class to update the state
                stream: RealTimeDBService().streamValueOfUserData(
                    args.indexOfThisField, daysArray[currentDayIndex]),
                builder: (context, snapshot) {
                  List listOfAllData;
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
                      child: FutureBuilder(
                        future: ListOfBlocksBuilder(listOfAllData),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                direction: Axis.vertical,
                                children: snapshot.data,
                              ),
                            );
                          } else {
                            return Container(
                                child: CircularProgressIndicator());
                          }
                        },
                      ));
                });
          },
        )
      ]),
    ));
  }
}

class ReserveButton extends StatelessWidget {
  const ReserveButton({
    Key key,
    @required this.rt,
    @required this.args,
    @required this.daysArray,
    @required this.currentDayIndex,
  }) : super(key: key);

  final RealTimeDBService rt;
  final DataOfUserAndFieldIndexOnly args;
  final List daysArray;
  final int currentDayIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.blue[700],
            textStyle: TextStyle(
              fontSize: 35,
            )),
        child: Text("احجز"),
        onPressed: () async {
          if (await rt.updateReservationData(
                  args.user,
                  args.indexOfThisField,
                  context.read<ProvidersModel>().slotsToBeReserved,
                  daysArray[currentDayIndex]) &&
              context.read<ProvidersModel>().slotsToBeReserved.isNotEmpty) {
            Navigator.pushNamed(context, '/CustomerInfo',
                arguments: DataWithoutNameAndPhoneNumber(
                    user: args.user,
                    indexOfThisField: args.indexOfThisField,
                    slotsReserved:
                        context.read<ProvidersModel>().slotsToBeReserved,
                    dayIndex: daysArray[currentDayIndex]));
          } else {
            print("didn't register : a message from slots page");
          }
        },
      ),
    );
  }
}
