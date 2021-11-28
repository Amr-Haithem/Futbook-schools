import 'dart:io';
import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/DataOfUserAndFieldIndexOnly.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Pages/Screens/Slots/singleButtonBlock.dart';
import 'package:futbook_school/Services/FirestoreService.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:futbook_school/Services/date.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class Slots extends StatefulWidget {
  // ignore: non_constant_identifier_names
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
  Map<String, String> weekdaysInArabic = {
    "1": "الإثنين",
    "2": "الثلاثاء",
    "3": "الأربعاء",
    "4": "الخميس",
    "5": "الجمعة",
    "6": "السبت",
    "7": "الأحد",
  };

  //static List;

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  int shifterHelper;
  bool somethingSelected = false;
  DateTime date;

  final FirestoreService _firestoreService = FirestoreService();
  final rt = RealTimeDBService();
  DataOfUserAndFieldIndexOnly args;

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

  Future<List<SingleButtonBlock>> listOfBlocksBuilder(
      List listOfAllData) async {
    //throw SocketException('يا حلاوة');
    try {
      int startTime =
          await _firestoreService.getThisSchoolDataStartTime(args.user.email);

      int endTime =
          await _firestoreService.getThisSchoolDataEndTime(args.user.email);
      startTime -= 8;
      endTime -= 8;
      if (startTime < 0) {
        startTime += 24;
      }

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
              reserved: true,
              arrived: listOfAllData[counter]['arrived'] == null ||
                      listOfAllData[counter]['arrived'] == false
                  ? false
                  : true,
              dayIndex: "day_" + daysArray[currentDayIndex].day.toString(),
              day: daysArray[currentDayIndex].day.toString() +
                  '-' +
                  daysArray[currentDayIndex].month.toString() +
                  '-' +
                  daysArray[currentDayIndex].year.toString(),
              field: args.indexOfThisField,
              user: args.user,
              reservationCost: listOfAllData[counter]['reservationCost'],
              userApp: listOfAllData[counter]['user_app']));
          counter++;
          sequentialIndex++;
        } else {
          listOfBlocks.add(SingleButtonBlock(
              sequentialIndex: sequentialIndex,
              slotMeaning: widget.SlotsMeaning[i],
              scale: 1,
              slots: listProviderForNumbersBiggerThan9(i),
              reserved: false,
              arrived: false));
          sequentialIndex++;
        }
      }
      return listOfBlocks;
    } on SocketException {
      return Future.error("مشكلة في الاتصال بالانترنت.اتصل و اعد المحاولة");
    } on HttpException {
      return Future.error(
          "مشكلة في تحميل الحجوزات برجاء الاتصال بخدمة العملاء");
    } on FormatException {
      return Future.error(
          "مشكلة في تحميل الحجوزات برجاء الاتصال بخدمة العملاء");
    } catch (e) {
      return Future.error(
          "مشكلة في تحميل الحجوزات برجاء الاتصال بخدمة العملاء");
    }
  }

  @override
  Future<void> initState() {
    super.initState();

    //ahmed sameh (is it a good practice?)
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
    });
    //i don't know what's this
    return null;
  }

  List daysArray = [];

  //functionalities of the arrows
  int currentDayIndex = 0;
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
          if (currentDayIndex < daysArray.length - 1) {
            currentDayIndex++;
            _isButton1Disabled = false;
          }
          if (currentDayIndex == daysArray.length - 1)
            _isButton2Disabled = true;
        });
      };
  }

  @override
  Widget build(BuildContext context) {
    Widget backToFiledsOrCancelButton() {
      if (context.read<ProvidersModel>().somethingSelected) {
        return SizedBox(
          width: 125,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red[700],
                textStyle: TextStyle(
                  fontSize: 35,
                )),
            child: Text("إلغاء"),
            onPressed: () async {
              // SingleButtonBlock().enteredValue.value = [];
            },
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

    return Scaffold(
        body: FutureBuilder(
      future: Date().fetchDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            date = snapshot.data;
            daysArray = [];

            for (int i = 0; i < 7; i++) {
              daysArray.add(date.add(Duration(days: i)));
            }
            return Container(
              color: Colors.grey[100],
              child: Wrap(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backToFiledsOrCancelButton(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            args.indexOfThisField.toString() + ' ملعب',
                            style: TextStyle(fontFamily: "Cairo", fontSize: 42),
                          ),
                          Text(
                              daysArray[currentDayIndex].day.toString() +
                                  '-' +
                                  daysArray[currentDayIndex].month.toString(),
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 30)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                    ), onPressed: () {  },
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                widget.weekdaysInArabic[
                                    daysArray[currentDayIndex]
                                        .weekday
                                        .toString()],
                                style: TextStyle(
                                    fontFamily: 'Cairo', fontSize: 30),
                              ),
                              SizedBox(width: 15),
                              Container(
                                width: 50,
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey[700]),
                                  onPressed: isForwardButtonEnabled(),
                                  // ignore: missing_required_param
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
                          currentDayIndex: currentDayIndex,
                          slotsMeaningGiver: slotsMeaningGiver,
                        )
                      ])
                    ],
                  ),
                ),
                StreamBuilder(
                  initialData: null,
                  stream:
                      _firestoreService.listenToDataFromSchoolList('schoolId'),
                  builder: (context, snapshot1) {
                    return StreamBuilder(
                        //here we can use provider along with sliderOfDays class to update the state
                        stream: RealTimeDBService().streamValueOfUserData(
                            args.user,
                            args.indexOfThisField,
                            'day_' + daysArray[currentDayIndex].day.toString()),
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
                                future: listOfBlocksBuilder(listOfAllData),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
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
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Text(
                                            snapshot.error.toString(),
                                            style: TextStyle(
                                                fontFamily: "Cairo",
                                                fontSize: 30),
                                          )),
                                          MaterialButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            color: Colors.white,
                                            textColor: Colors.black,
                                            child: Icon(
                                              Icons.refresh_rounded,
                                              size: 33,
                                            ),
                                            padding: EdgeInsets.all(16),
                                            shape: CircleBorder(),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red[700],
                                                textStyle: TextStyle(
                                                  fontSize: 30,
                                                )),
                                            child: Text("رجوع"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  } else {
                                    return Container(
                                        alignment: Alignment.center,
                                        child: SpinKitFoldingCube(
                                          color: Colors.green,
                                        ));
                                  }
                                },
                              ));
                        });
                  },
                )
              ]),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(fontFamily: "Cairo", fontSize: 30),
                )),
                MaterialButton(
                  onPressed: () {
                    setState(() {});
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 33,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red[700],
                      textStyle: TextStyle(
                        fontSize: 30,
                      )),
                  child: Text("رجوع"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        } else {
          return Container(
              alignment: Alignment.center,
              child: SpinKitFoldingCube(
                color: Colors.green,
              ));
        }
      },
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
    @required this.slotsMeaningGiver,
  }) : super(key: key);

  final RealTimeDBService rt;
  final DataOfUserAndFieldIndexOnly args;
  final List daysArray;
  final int currentDayIndex;
  final Function slotsMeaningGiver;

  List returningTheActualSlots(List s) {
    List x = [];
    for (var i = 0; i < s.length; i++) {
      if (s[i].toString()[0] == 'a' ||
          s[i].toString()[0] == 'b' ||
          s[i].toString()[0] == 'c' ||
          s[i].toString()[0] == 'd' ||
          s[i].toString()[0] == 'e' ||
          s[i].toString()[0] == 'f' ||
          s[i].toString()[0] == 'g' ||
          s[i].toString()[0] == 'h') {
        x.add(int.parse(s[i].toString().substring(1)));
      } else {
        x.add(int.parse(s[i].toString()));
      }
    }
    print("hello");
    print(x);
    return x;
  }

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
          if (await rt
                  .updateReservationData(
                      args.user,
                      args.indexOfThisField,
                      context.read<ProvidersModel>().slotsToBeReserved,
                      "day_" + daysArray[currentDayIndex].day.toString())
                  .catchError((e) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: Text("فشل في العملية",
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 23)),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(e,
                                    style: TextStyle(
                                        fontFamily: "Cairo", fontSize: 20)),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("رجوع",
                                  style: TextStyle(
                                      fontFamily: "Cairo", fontSize: 20)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }) &&
              context.read<ProvidersModel>().slotsToBeReserved.isNotEmpty) {
            Navigator.pushNamed(context, '/CustomerInfo',
                arguments: DataWithoutNameAndPhoneNumber(
                    user: args.user,
                    indexOfThisField: args.indexOfThisField,
                    duration: slotsMeaningGiver(returningTheActualSlots(
                        context.read<ProvidersModel>().slotsToBeReserved)),
                    slotsReserved:
                        context.read<ProvidersModel>().slotsToBeReserved,
                    dayIndex:
                        "day_" + daysArray[currentDayIndex].day.toString(),
                    realDate: (daysArray[currentDayIndex].day.toString() +
                            "-" +
                            daysArray[currentDayIndex].month.toString() +
                            "-" +
                            daysArray[currentDayIndex].year.toString())
                        .toString(),
                    dayWeekdayArabic: Slots().weekdaysInArabic[
                        daysArray[currentDayIndex].weekday.toString()]));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: Text("فشل في العملية",
                          style: TextStyle(fontFamily: "Cairo", fontSize: 23)),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('اختر اوقات متاحة للحجز',
                                style: TextStyle(
                                    fontFamily: "Cairo", fontSize: 20)),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("رجوع",
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                });
            print("didn't register : a message from slots page");
          }
        },
      ),
    );
  }
}
