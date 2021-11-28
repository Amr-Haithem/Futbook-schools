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
      {this.arrived,
      this.nameOfCustomer,
      this.phoneNumber,
      this.indexOfThisField,
      this.slotsMeaning,
      this.dayIndex,
      this.slots,
      this.day,
      this.user,
      this.reservationCost,
      this.userApp});
}
