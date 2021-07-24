import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//the following is the equality class to compare two lists
import 'package:collection/collection.dart';

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
          .child("reserved")
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
            .child(slotIndices[i].toString())
            .update({"reserved": true});
      }
      print("slots reserved");
      return true;
    } else {
      print("you can't reserve these slots");
      return false;
    }
  }

  Future<bool> updateNameAndPhoneNumberForCustomer(User user, int fieldIndex,
      List slotIndices, String nameOfClient, String phoneNumber) async {
    for (int i = 0; i < slotIndices.length; i++) {
      await databaseReference
          .child("Reservation_Data")
          //will be replaced by user from email
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .child(slotIndices[i].toString())
          .update({
        "phoneNumberOfCustomer": phoneNumber,
        "nameOfCustomer": nameOfClient
      });
    }
  }

  Future<Map> unReserveSlots(
      User user, int fieldIndex, List slotIndices) async {
    for (int i = 0; i < slotIndices.length; i++) {
      await databaseReference
          .child("Reservation_Data")
          //will be replaced by user from email
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .child(slotIndices[i].toString())
          .update({
        "phoneNumberOfCustomer": "none",
        "nameOfCustomer": "none",
        "reserved": false
      });
      print("unreserved slot " + slotIndices[i].toString());

      // here we implement a dynamic way to set data in the EachReservationData
    }
  }
//listener function to listen to slots changed in a particular day in a particular field
  void listenToThisPageSlots(
      User user, int fieldIndex) {
    for(int i = 0;i<14;i++){

      FirebaseDatabase.instance
          .reference()
          .child("Reservation_Data")
      //will be replaced by user from email
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .child(i.toString())
          .onChildChanged
          .listen((Event event) {
        print("yeaaaah we listened");
        // process event
      });

    }
  }

  /*where onXxx is one of

  value
  onChildAdded
  onChildRemoved
  onChildChanged*/



  void deleteData() {
    databaseReference.child("1").remove();
  }

  //generate my school system of solution one

  Future<void> InitializeSchoolDBAutomatically() async {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 7; j++) {
        for (int k = 0; k < 15; k++) {
          await databaseReference
              .child("Reservation_Data")
              .child("UndefinedSchool")
              .child(i.toString())
              .child("day" + j.toString())
              .child(k.toString())
              .set({
            "reserved": false,
            "nameOfCustomer": "none",
            "phoneNumberOfCustomer": "none"
          });
        }
      }
    }
  }

  //functional methods (not database related):
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

  //this function compares the values of two lists
  Function eq = const ListEquality().equals;
}
