import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';

import '../../../Models/DataWithNameAndPhoneNumber.dart';

//what is this
//  const CustomerInfo({Key? key}) : super(key: key);
class CustomerInfo extends StatefulWidget {
  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

String NameOfCustomer = '';
String PhoneNumber = '';

class _CustomerInfoState extends State<CustomerInfo> {
  final _formKey = GlobalKey<FormState>();
  final rt = RealTimeDBService();

  @override
  Widget build(BuildContext context) {
    final DataWithoutNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          elevation: 1.0,
          title: Text('ادخل الأسم و رقم التليفون'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
                height: 639,
                color: Colors.lightGreenAccent,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      child: TextFormField(
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: 'ادخل اسم العميل',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ادخل اسم العميل ';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => NameOfCustomer = val);
                          }),
                    ),
                    SizedBox(height: 70.0),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      child: TextFormField(
                          style: TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: 'ادخل رقم العميل',
                          ),
                          validator: (value) {
                            if (value.length < 11 || value.isEmpty) {
                              return 'PhoneNumber has to be more than 11 characters ';
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => PhoneNumber = val);
                          }),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      child: Text(
                        'finish and give invoice',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          rt.reserveForCustomer(
                              args.user,
                              args.indexOfThisField,
                              args.slotsReserved,
                              NameOfCustomer,
                              PhoneNumber);
                          //sending to invoice to show data
                          Navigator.pushNamed(context, '/Invoice',
                              arguments: DataWithNameAndPhoneNumber(
                                  nameOfCustomer: NameOfCustomer,
                                  PhoneNumber: PhoneNumber,
                                  user: args.user,
                                  indexOfThisField: args.indexOfThisField,
                                  slotsReserved: args.slotsReserved));
                        }
                      },
                    )
                  ],
                )),
          ),
        ));
  }
}
