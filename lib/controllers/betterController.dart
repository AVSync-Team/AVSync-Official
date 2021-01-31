import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RishabhController extends GetxController {
  void rishabhTry() {
    print('called');
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase.child('bsdk').set({'name' : 'rishabh','loda' : 'rand'});
  }
}
