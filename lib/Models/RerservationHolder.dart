class ReservationHolder {
  String name;
  String phoneNumber;
  List slots;
  ReservationHolder({this.name, this.phoneNumber, this.slots});

  int getSlotsNumber() {
    return slots.length;
  }
}