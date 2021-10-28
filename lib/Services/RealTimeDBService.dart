import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//the following is the equality class to compare two lists
import 'package:collection/collection.dart';
import 'package:http/http.dart';

class RealTimeDBService {
  String listProviderForNumbersBiggerThan9(int theNumber) {
    List<String> chars = ["a", "b", "c", "d", "e", "f", "g", "h"];
    if (theNumber > 9) {
      return chars[theNumber - 10] + theNumber.toString();
    } else {
      return theNumber.toString();
    }
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<bool> checkInstantlyIfReserved(
      String userEmail,
      int requestedFieldIndex,
      List requestedSlotsIndices,
      String dayIndex) async {
    print('sorry daawg');
    print(dayIndex);
    bool availability = true;
    for (int i = 0; i < requestedSlotsIndices.length; i++) {
      await databaseReference
          .child("Reservation_Data")
          //will be replaced by user from email
          .child(getUserNameFromEmailAddress(userEmail))
          .child(dayIndex)
          .child(requestedFieldIndex.toString())
          .child(requestedSlotsIndices[i][0].toString())
          .once()
          .then((DataSnapshot dss) {
        if (dss.value as bool == true) {
          availability = false;
        }
      });
    }
    return availability;
  }

//todo pass a whole map other than a for loop

  String returningTheActualSlots(String s) {
    if (s[0] == 'a' ||
        s[0] == 'b' ||
        s[0] == 'c' ||
        s[0] == 'd' ||
        s[0] == 'e' ||
        s[0] == 'f' ||
        s[0] == 'g' ||
        s[0] == 'h') {
      String x = s.substring(1);
      return x;
    } else {
      return s;
    }
  }

  Future<bool> updateReservationData(
      User user, int fieldIndex, List slotIndices, String dayIndex) async {
    print(getUserNameFromEmailAddress(user.email));

    if (await checkInstantlyIfReserved(getUserNameFromEmailAddress(user.email),
        fieldIndex, slotIndices, dayIndex)) {
      Map<String, bool> slotsToBeReserved = {};
      for (int i = 0; i < slotIndices.length; i++) {
        {
          slotsToBeReserved.putIfAbsent(
              returningTheActualSlots(slotIndices[i][0].toString()),
              () => true);
        }
      }
      await databaseReference
          .child("Reservation_Data")
          .child(getUserNameFromEmailAddress(user.email))
          .child(dayIndex)
          .child(fieldIndex.toString())
          .update(slotsToBeReserved);

      print("slots reserved");
      return true;
    } else {
      print("you can't reserve these slots");
      return false;
    }
  }

  List getSlotsFromEmbeddedArray(List slotIndices) {
    List x = [];

    for (int i = 0; i < slotIndices.length; i++) {
      x.add(int.parse(returningTheActualSlots(slotIndices[i][0].toString())));
    }

    return x;
  }

  Future<bool> UpdateUserData(User user, int fieldIndex, List slotIndices,
      String nameOfClient, String phoneNumber, String dayIndex) async {
    //updating User data "the data of reservation"
    await databaseReference
        .child("User data")
        //will be replaced by user from email
        .child(getUserNameFromEmailAddress(user.email))
        .child(dayIndex)
        .child(fieldIndex.toString())
        .child(slotIndices[0][0].toString() +
            '-' +
            slotIndices[slotIndices.length - 1][0].toString())
        .set({
      "phoneNumberOfCustomer": phoneNumber,
      "nameOfCustomer": nameOfClient,
      "slots": getSlotsFromEmbeddedArray(slotIndices)
    });
  }

  Future<Map> unReserveReservationDataSlots(
      User user, int fieldIndex, List slotIndices, String dayIndex) async {
    Map<String, dynamic> x = {};
    for (int i = 0; i < slotIndices.length; i++) {
      x.putIfAbsent(slotIndices[i][0].toString(), () => null);
    }
    print(x);
    await databaseReference
        .child("Reservation_Data")
        //will be replaced by user from email
        .child(getUserNameFromEmailAddress(user.email))
        .child(dayIndex)
        .child(fieldIndex.toString())
        .update(x);
    print("unreserved slots in due to incomplete reservation process");
  }

//listener function to listen to slots changed in a particular day in a particular field
//this listener downloads one kilo bytes each time it downloads data
  Stream streamValueOfUserData(User user, int fieldIndex, String dayIndex) {
    return FirebaseDatabase.instance
        .reference()
        .child("User data")
        .child(getUserNameFromEmailAddress(user.email))
        .child(dayIndex)
        .child(fieldIndex.toString())
        //todo take a look if to change on vlaue
        .onValue;
  }

  Future<void> updatingArrivedReservations(User schoolUser,
      int requestedFieldIndex, String reservationKey, String dayIndex) async {
    await databaseReference
        .child("User data")
        //will be replaced by user from email
        .child(getUserNameFromEmailAddress(schoolUser.email))
        .child(dayIndex)
        .child(requestedFieldIndex.toString())
        .child(reservationKey)
        .update({'arrived': true});
  }

//functional methods (not database related):

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
              .update({k.toString(): false});
        }
      }
    }
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

//this function compares the values of two lists
  Function eq = const ListEquality().equals;
}
