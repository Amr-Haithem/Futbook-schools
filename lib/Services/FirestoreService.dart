import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //List<Map<String,dynamic>> schoolList = [];
  //List<Map<String,dynamic>> userList = [];

  CollectionReference schoolsList =
      FirebaseFirestore.instance.collection('Schools_List');

  CollectionReference general_Flags =
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
      Map x = {};
      await schoolsList.doc(getUserNameFromEmailAddress(schoolEmail)).get().then((value) {
        x = value.data();
      });
      return x['startTime'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  Future<int> getThisSchoolDataEndTime(String schoolEmail) async {
    try {
      Map x = {};
      await schoolsList.doc(getUserNameFromEmailAddress(schoolEmail)).get().then((value) {
        x = value.data();
      });
      return x['endTime'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  Future<int> getNumberOfFieldsFunc(String schoolEmail) async {
    try {
      Map x = {};
      await schoolsList.doc(getUserNameFromEmailAddress(schoolEmail)).get().then((value) {
        x = value.data();
      });
      return x['numberOfFields'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  Future<String> getSchoolRealName(String schoolEmail) async {
    try {
      Map x = {};
      await general_Flags.doc('schoolNames').get().then((value) {
        x = value.data();
      });
      return x[schoolEmail];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  //getting stream from schools list data firestore
  Stream listenToDataFromSchoolList(String schoolEmail) {
    return schoolsList.doc(getUserNameFromEmailAddress(schoolEmail)).snapshots();
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
