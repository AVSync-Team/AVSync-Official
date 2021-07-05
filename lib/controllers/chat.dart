import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
//yeh hai vadio app
import 'package:get/get.dart';

var randomNumber = 0.obs;
int randomGenerator() {
  Random random = new Random();
  randomNumber.value = random.nextInt(100000);
  return randomNumber.value;
}

class ChatController extends GetxController {
  void sendMessage(
      {String firebaseId, String message, String userId, String username}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    print("CheckUsrName: $username");
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .push()
        .set({
      "message": message,
      "userId": userId,
      "messageId": DateTime.now().toIso8601String(),
      "username": username
    });
  }

  Stream<Event> message({String firebaseId}) {
    final DatabaseReference firebasedatbase =
        FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .orderByChild("messageId")
        .onValue;
  }
}
