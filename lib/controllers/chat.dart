import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:get/get.dart';

var randomNumber = 0.obs;
int randomGenerator() {
  Random random = new Random();
  randomNumber.value = random.nextInt(100000);
  return randomNumber.value;
}

class ChatController extends GetxController {
  void sendMessage({String firebaseId, String message, String userId,String username}) {
    Timestamp stamp = Timestamp.now();
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .push()
        .set({
      "message": message,
      "userId": userId,
      "messageId": DateTime.now().toIso8601String(),
      "username":username
    });
  }

  Stream message({String firebaseId}) {
    final firebasedatbase = FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .orderByChild("messageId")
        .onValue;
  }
}
