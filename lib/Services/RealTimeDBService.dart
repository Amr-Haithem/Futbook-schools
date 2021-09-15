import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

//the following is the equality class to compare two lists
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:futbook_school/Models/RerservationHolder.dart';
import 'package:futbook_school/Pages/Screens/Slots/Slots.dart';
import 'package:provider/provider.dart';

class RealTimeDBService {
  final databaseReference = FirebaseDatabase.instance.reference();

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
            .update(
                {returningTheActualSlots(slotIndices[i][0].toString()): true});
      }
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
      x.add(int.parse(returningTheActualSlots(slotIndices[i][0])));
    }
    return x;
  }

  Future<bool> UpdateUserData(User user, int fieldIndex, List slotIndices,
      String nameOfClient, String phoneNumber) async {
    for (int i = 0; i < slotIndices.length; i++) {
      //updating User data "the data of reservation"
      await databaseReference
          .child("User data")
          //will be replaced by user from email
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .child(slotIndices[0][0].toString() +
              '-' +
              slotIndices[slotIndices.length - 1][0].toString())
          .set({
        "phoneNumberOfCustomer": phoneNumber,
        "nameOfCustomer": nameOfClient,
        "slots": getSlotsFromEmbeddedArray(slotIndices)
      });
    }
  }

  Future<Map> unReserveSlots(
      User user, int fieldIndex, List slotIndices) async {
    await databaseReference
        .child("User data")
        //will be replaced by user from email
        .child("UndefinedSchool")
        .child(fieldIndex.toString())
        .child("day0")
        .child(slotIndices[0].toString() +
            '-' +
            slotIndices[slotIndices.length - 1].toString())
        .remove();
    for (int i = 0; i < slotIndices.length; i++) {
      await databaseReference
          .child("Reservation_Data")
          //will be replaced by user from email
          .child("UndefinedSchool")
          .child(fieldIndex.toString())
          .child("day0")
          .update({slotIndices[i].toString(): false});
    }
    print("unreserved slot " +
        slotIndices.toString() +
        "and removed it from User data");
  }

//listener function to listen to slots changed in a particular day in a particular field
  //this listener downloads one kilo bytes each time it downloads data
  Stream streamValueOfUserData(int fieldIndex) {
    return FirebaseDatabase.instance
        .reference()
        .child("User data")
        .child("UndefinedSchool")
        .child(fieldIndex.toString())
        .child("day0")
        //todo take a look if to change on vlaue
        .onValue;
  }

  //remove a certain listener
  void removeListener() {
    // databaseReference.removeEventListener(valueEventListener);
  }

  /*FirebaseDatabase.instance.reference().child("Reservation_Data")
        .child("UndefinedSchool")
        .child(fieldIndex.toString())
        .child("day0")*/

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
