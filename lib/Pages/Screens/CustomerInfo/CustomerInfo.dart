import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';
import 'package:futbook_school/Services/RealTimeDBService.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final DataWithoutNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Assets/Images/pitch_1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 40,
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
              Container(
                height: height,
                child: Wrap(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        height: height * .2,
                        width: width * .4,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Futbook",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Cairo",
                                fontSize: 45),
                          ),
                        )),
                    Form(
                      key: _formKey,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 80.0, horizontal: 200.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    ':اسم العميل',
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 28,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.0),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 20,
                                        color: Colors.black),
                                    decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.yellowAccent,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        hintStyle: TextStyle(
                                            fontFamily: "Cairo", fontSize: 20),
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: "ادخل اسم العميل"),
                                    validator: (value) {
                                      if (value == '') {
                                        return "ادخل اسم العميل بشكل صحيح";
                                      } else
                                        return null;
                                    },
                                    onChanged: (val) {
                                      setState(() => NameOfCustomer = val);
                                    }),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    ':رقم تليفون العميل',
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 28,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                    autofocus: true,
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 18,
                                        color: Colors.black),
                                    decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.yellowAccent,
                                        ),
                                        hintTextDirection: TextDirection.rtl,
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintStyle: TextStyle(
                                            fontFamily: "Cairo", fontSize: 20),
                                        border: OutlineInputBorder(),
                                        hintText: 'ادخل رقم تليفون العميل'),
                                    validator: (value) {
                                      if (value.length < 11 || value.isEmpty) {
                                        return "ادخل رقم العميل الصحيح";
                                      } else
                                        return null;
                                    },
                                    obscureText: true,
                                    onChanged: (val) {
                                      setState(() => PhoneNumber = val);
                                    }),
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(160, 65),
                                  primary: Colors.blue, // background
                                  onPrimary: Colors.yellow, // foreground
                                ),
                                child: Text(
                                  'تأكيد الحجز',
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await rt.UpdateUserData(
                                        args.user,
                                        args.indexOfThisField,
                                        args.slotsReserved,
                                        NameOfCustomer,
                                        PhoneNumber,
                                        args.dayIndex);
                                    Navigator.of(context).pop();
                                  }
                                },
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
