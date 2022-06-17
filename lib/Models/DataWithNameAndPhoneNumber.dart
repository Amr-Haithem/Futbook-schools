import 'package:firebase_auth/firebase_auth.dart';

class DataWithNameAndPhoneNumber {
  final int indexOfThisField;
  final String slotsMeaning;
  final String nameOfCustomer;
  final String phoneNumber;
  final String day;
  final List slots;
  final bool arrived;
  final User user;
  final num reservationCost;
  final bool userApp;
  final String dayIndex;

  DataWithNameAndPhoneNumber(
      {required this.arrived,
      required this.nameOfCustomer,
      required this.phoneNumber,
      required this.indexOfThisField,
      required this.slotsMeaning,
      required this.dayIndex,
      required this.slots,
      required this.day,
      required this.user,
      required this.reservationCost,
      required this.userApp});
}
