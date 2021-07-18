import 'package:firebase_auth/firebase_auth.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';

class DataWithNameAndPhoneNumber {
  final User user;
  final int indexOfThisField;
  final slotsReserved;
  final String nameOfCustomer;
  final String PhoneNumber;

  DataWithNameAndPhoneNumber(
      {this.nameOfCustomer,
      this.PhoneNumber,
      this.user,
      this.indexOfThisField,
      this.slotsReserved});
}
