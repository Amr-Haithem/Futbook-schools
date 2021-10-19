import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:provider/src/provider.dart';

//What's this
//const Invoice({Key? key}) : super(key: key);
class Invoice extends StatefulWidget {
  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final rt = RealTimeDBService();
  bool selectedNow = false;

  String getChildOfDayFromSlots(List theNumbers) {
    List<String> chars = ["a", "b", "c", "d", "e", "f", "g", "h"];
    String s;
    if (theNumbers[0] > 9) {
      s = chars[theNumbers[0] - 10] + theNumbers[0].toString() + '-';
    } else {
      s = theNumbers[0].toString() + '-';
    }
    if (theNumbers[theNumbers.length - 1] > 9) {
      s += chars[theNumbers[theNumbers.length - 1] - 10] +
          theNumbers[theNumbers.length - 1].toString();
    } else {
      s += theNumbers[theNumbers.length - 1].toString();
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final DataWithNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;

    Row ifNotArrivedShow() {
      if (args.arrived || selectedNow) {
        return Row();
      } else {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      textStyle: TextStyle(
                        fontSize: 35,
                      )),
                  onPressed: () {},
                  child: Text("إلغاء الحجز",
                      style: TextStyle(fontFamily: "Cairo", fontSize: 22)),
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent[700],
                      textStyle: TextStyle(
                        fontSize: 35,
                      )),
                  onPressed: () async {
                    setState(() {
                      selectedNow = true;
                    });
                    print(getChildOfDayFromSlots(args.slots));
                    rt.updatingArrivedReservations(
                        'schoolUser',
                        args.indexOfThisField,
                        getChildOfDayFromSlots(args.slots),
                        args.Day);
                  },
                  child: Text("تأكيد الدفع",
                      style: TextStyle(fontFamily: "Cairo", fontSize: 23)),
                ),
              ),
            ]);
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/Assets/Images/pitch_1.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 30,
              child: MaterialButton(
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
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //color: Colors.white.withOpacity(.9),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                      color: Colors.white.withOpacity(.9)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Text((args.indexOfThisField + 1).toString() + "ملعب ",
                            style:
                                TextStyle(fontFamily: "Cairo", fontSize: 40)),
                        SizedBox(height: 30),
                        Text(args.slotsMeaning,
                            style:
                                TextStyle(fontFamily: "Cairo", fontSize: 30)),
                        SizedBox(height: 30),
                        Text(args.nameOfCustomer,
                            style:
                                TextStyle(fontFamily: "Cairo", fontSize: 40)),
                        SizedBox(height: 30),
                        Text(args.PhoneNumber,
                            style:
                                TextStyle(fontFamily: "Cairo", fontSize: 30)),
                        SizedBox(height: 30),
                        Text(200.toString() + " EGP",
                            style:
                                TextStyle(fontFamily: "Cairo", fontSize: 45)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ifNotArrivedShow()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
