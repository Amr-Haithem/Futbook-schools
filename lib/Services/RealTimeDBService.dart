import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDBService {
  final databaseReference = FirebaseDatabase.instance.reference();

  void writeData() {
    databaseReference
        .child("Reservation_Data")
        .set({'1': 'ID1', 'data': 'this is a sample data'});
  }

  void readData() {
    databaseReference
        .child("Reservation_Data")
        .child("UndefinedSchool")
        .once()
        .then((DataSnapshot dataSnapShot) {
      print(dataSnapShot.value);
    });
  }

  Future<bool> checkInstantlyIfReserved(String schoolUser,
      int requestedFieldIndex, List requestedSlotsIndices) async {
    bool availability = true;
    for (int i = 0; i < requestedSlotsIndices.length; i++) {
      await databaseReference
          .child("Reservation_Data")
          //will be replaced by user from email
          .child("UndefinedSchool")
          .child(requestedFieldIndex.toString())
          .child("day0")
          .child(requestedSlotsIndices[i].toString())
          .once()
          .then((DataSnapshot dss) {
        if (dss.value as bool == true) {
          availability = false;
        }
      });
    }
    return availability;
  }

  Future<bool> updateReservationData(
      User user, int fieldIndex, List slotIndices) async {
    print(getUserNameFromEmailAddress(user.email));

    if (await checkInstantlyIfReserved(
        getUserNameFromEmailAddress(user.email), fieldIndex, slotIndices)) {
      for (int i = 0; i < slotIndices.length; i++) {
        await databaseReference
            .child("Reservation_Data")
        //will be replaced by user from email
            .child("UndefinedSchool")
            .child(fieldIndex.toString())
            .child("day0")
            .update({slotIndices[i].toString(): true});

      }
      print("registerd");
      return true;
    } else {
      print("you can't register");
      return false;
    }

    /**/
  }

  void deleteData() {
    databaseReference.child("1").remove();
  }

  //functional methods (not database related)
  String getUserNameFromEmailAddress(String s) {
    String newS = "";
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '@') {
        break;
      }
      newS += s[i];
    }
    return newS;
  }
}
