import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithNameAndPhoneNumber.dart';
import 'package:futbook_school/Models/ProvidersModel.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';
import 'package:provider/src/provider.dart';

//What's this
//const Invoice({Key? key}) : super(key: key);
class Invoice extends StatelessWidget {
  final rt = RealTimeDBService();

  @override
  Widget build(BuildContext context) {
    final DataWithNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "invoice",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 310.0),
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(args.indexOfThisField.toString() + "ملعب ",
                        style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                    SizedBox(height: 50),
                    Text(args.PhoneNumber,
                        style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                    SizedBox(height: 50),
                    Text(args.nameOfCustomer,
                        style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                    SizedBox(height: 50),
                    Text(args.slotsMeaning,
                        style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                    Text(200.toString() + " EGP",
                        style: TextStyle(fontFamily: "Cairo", fontSize: 30)),
                  ],
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        print(

                            context
                                .read<ProvidersModel>()
                                .slotsOfThisReservationToConfirmArrival);
                        rt.updatingArrivedReservations(
                            'schoolUser',
                            args.indexOfThisField,
                            context
                                .read<ProvidersModel>()
                                .slotsOfThisReservationToConfirmArrival,
                            args.Day);
                      },
                      child: Text("تأكيد الحجز",
                          style: TextStyle(fontFamily: "Cairo", fontSize: 22)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("إلغاء الحجز",
                          style: TextStyle(fontFamily: "Cairo", fontSize: 22)),
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
