import 'package:firebase_auth/firebase_auth.dart';

class DataWithoutNameAndPhoneNumber {
  final User user;
  final int indexOfThisField;
  final List slotsReserved;
  final String dayIndex;
  final String dayWeekdayArabic;
  final String duration;
  final String realDate;

  DataWithoutNameAndPhoneNumber(
      {this.user,
      this.indexOfThisField,
      this.slotsReserved,
      this.dayIndex,
      this.realDate,
      this.dayWeekdayArabic,
      this.duration});
}
