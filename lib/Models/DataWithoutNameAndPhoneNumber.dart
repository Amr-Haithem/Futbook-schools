
import 'package:firebase_auth/firebase_auth.dart';

class DataWithoutNameAndPhoneNumber{
  final User user;
  final int indexOfThisField;
  final List slotsReserved;
  final String dayIndex;

  DataWithoutNameAndPhoneNumber(
      {this.user, this.indexOfThisField, this.slotsReserved,this.dayIndex});

}