import 'package:flutter/material.dart';
import 'package:futbook_school/Models/DataWithNameAndPhoneNumber.dart';
//What's this
//const Invoice({Key? key}) : super(key: key);
class Invoice extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final DataWithNameAndPhoneNumber args =
        ModalRoute.of(context).settings.arguments;

    return Container(
      child: Text(
        args.nameOfCustomer+", "+args.PhoneNumber+", "+args.indexOfThisField.toString()+", "+args.user.email+", "+args.slotsReserved.toString()

      ),
    );
  }
}
