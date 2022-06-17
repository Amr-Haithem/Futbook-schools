import 'package:firebase_auth/firebase_auth.dart';

class DataWithoutNameAndPhoneNumber {
  final User user;
  final int indexOfThisField;
  final List/*!*//*!*/ slotsReserved;
  final String dayIndex;
  final String dayWeekdayArabic;
  final String duration;
  final String realDate;

  DataWithoutNameAndPhoneNumber(
      {required this.user,
      required this.indexOfThisField,
      required this.slotsReserved,
      required this.dayIndex,
      required this.realDate,
      required this.dayWeekdayArabic,
      required this.duration});
}
