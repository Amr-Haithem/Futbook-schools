import 'package:firebase_auth/firebase_auth.dart';
import 'package:futbook_school/Models/DataWithoutNameAndPhoneNumber.dart';

class DataWithNameAndPhoneNumber {
  final int indexOfThisField;
  final String slotsMeaning;
  final String nameOfCustomer;
  final String PhoneNumber;
  final String Day;

  DataWithNameAndPhoneNumber(
      {this.nameOfCustomer,
      this.PhoneNumber,
      this.indexOfThisField,
      this.slotsMeaning,this.Day});
}
