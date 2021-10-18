import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //List<Map<String,dynamic>> schoolList = [];
  //List<Map<String,dynamic>> userList = [];

  CollectionReference schoolsList =
      FirebaseFirestore.instance.collection('Schools_List');

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

  Future<int> getThisSchoolDataStartTime(String schoolDocName) async {
    try {
      Map x = {};
      await schoolsList.doc('School_4').get().then((value) {
        x = value.data();
      });
      return x['startTime'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  Future<int> getThisSchoolDataEndTime(String schoolDocName) async {
    try {
      Map x = {};
      await schoolsList.doc('School_4').get().then((value) {
        x = value.data();
      });
      return x['endTime'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }
  Future<int> getNumberOfFieldsFunc(String schoolDocName) async {
    try {
      Map x = {};
      await schoolsList.doc('School_4').get().then((value) {
        x = value.data();
      });
      return x['numberOfFields'];
    } catch (e) {
      print('error in getting school start time data');
      return null;
    }
  }

  //getting stream from schools list data firestore
  Stream listenToDataFromSchoolList(String schoolId) {
    return schoolsList.doc('School_4').snapshots();
  }
}

