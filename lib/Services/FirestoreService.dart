import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //List<Map<String,dynamic>> schoolList = [];
  //List<Map<String,dynamic>> userList = [];

  CollectionReference schoolsList =
      FirebaseFirestore.instance.collection('Schools_List');

  // ignore: non_constant_identifier_names
  CollectionReference generalFlags =
      FirebaseFirestore.instance.collection('General_Flags');

  Future<void> getSchoolData(String schoolDocName) async {
    try {
      await schoolsList.get().then((value) {
        value.docs.forEach((element) {
          print(element.data());
        });
      });
    } catch (e) {
      print('hello error');
    }
  }

  Future<int> getThisSchoolDataStartTime(String schoolEmail) async {
    try {
      Map? x = {};
      await schoolsList
          .doc(getUserNameFromEmailAddress(schoolEmail))
          .get()
          .then((value) {
        x = value.data() as Map<dynamic, dynamic>?;
      });
      return x!['startTime'];
    } on SocketException {
      return Future.error(
          "فشلت العملية تأكد من الأتصال بالأنترنت و أعد المحاولة");
    } on HttpException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } on FormatException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } catch (e) {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    }
  }

  Future<int> getThisSchoolDataEndTime(String schoolEmail) async {
    try {
      Map/*!*//*!*/ x = {};
      await schoolsList
          .doc(getUserNameFromEmailAddress(schoolEmail))
          .get()
          .then((value) {
        x = value.data() as Map<dynamic, dynamic>;
      });
      return x['endTime'];
    } on SocketException {
      return Future.error(
          "فشلت العملية تأكد من الأتصال بالأنترنت و أعد المحاولة");
    } on HttpException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } on FormatException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } catch (e) {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    }
  }

  Future<int> getNumberOfFieldsFunc(String schoolEmail) async {
    try {
      //throw SocketException('message');

      Map/*!*/ x = {};
      await schoolsList
          .doc(getUserNameFromEmailAddress(schoolEmail))
          .get()
          .then((value) {
        x = value.data() as Map<dynamic, dynamic>;
      });
      return x['numberOfFields'];
    } on SocketException {
      return Future.error(
          "فشلت العملية تأكد من الأتصال بالأنترنت و أعد المحاولة");
    } on HttpException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } on FormatException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } catch (e) {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    }
  }

  Future<String> getSchoolRealName(String? schoolEmail) async {
    try {
      //throw SocketException('message');
      Map/*!*/ x = {};
      await generalFlags.doc('schoolNames').get().then((value) {
        x = value.data() as Map<dynamic, dynamic>;
      });
      return x[schoolEmail];
    } on SocketException {
      return Future.error(
          "فشلت العملية تأكد من الأتصال بالأنترنت و أعد المحاولة");
    } on HttpException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } on FormatException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } catch (e) {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    }
  }

  //getting stream from schools list data firestore
  Stream listenToDataFromSchoolList(String schoolEmail) {
    return schoolsList
        .doc(getUserNameFromEmailAddress(schoolEmail))
        .snapshots();
  }

  Future<num?> getPriceOfReservation(String/*!*/ schoolEmail, int fieldIndex) async {
    try {
      Map/*!*/ x = {};

      await schoolsList
          .doc(getUserNameFromEmailAddress(schoolEmail))
          .get()
          .then((value) {
        x = value.data() as Map<dynamic, dynamic>;
      });
      print(x);
      print(x['fieldsCosts']);
      print(x['fieldsCosts']["field" + fieldIndex.toString()]);
      return x['fieldsCosts']["field" + fieldIndex.toString()];
    } on SocketException {
      return Future.error(
          "فشلت العملية تأكد من الأتصال بالأنترنت و أعد المحاولة");
    } on HttpException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } on FormatException {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
    } catch (e) {
      return Future.error("فشلت العملية برجاء إعادة المحاولة");
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
}
