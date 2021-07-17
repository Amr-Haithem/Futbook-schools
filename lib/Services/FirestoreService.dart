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
    } catch (e) {}
  }
}
/*
* {
      'number': phoneNumber,
      'email': email,
      'name': name,
      'points': 0,
      'isEmailVerified': false,
    }*/
