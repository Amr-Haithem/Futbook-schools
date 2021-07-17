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
    databaseReference.once().then((DataSnapshot dataSnapShot) {
      print(dataSnapShot.value);
    });
  }

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

  void updateReservationData(User user, int fieldIndex, List slotIndices) {
    print(getUserNameFromEmailAddress(user.email));
    for(int i = 0;i<slotIndices.length;i++){
      databaseReference
          .child("Reservation_Data")
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .update({slotIndices[i].toString(): true});
    }
  }

  void deleteData() {
    databaseReference.child("1").remove();
  }
}
