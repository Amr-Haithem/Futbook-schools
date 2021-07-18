import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';

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

  @override
  Widget build(BuildContext context) {
    final DataWithoutNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          elevation: 1.0,
          title: Text('put name and phone number'),
        ),
        body: Form(
          key: _formKey,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(validator: (value) {
                    if (value.isEmpty) {
                      return 'plz enter Name Of Customer ';
                    }
                    return null;
                  }, onChanged: (val) {
                    setState(() => NameOfCustomer = val);
                  }),
                  SizedBox(height: 20.0),
                  TextFormField(
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                      'finish and give invoice',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
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
        ));
  }
}
