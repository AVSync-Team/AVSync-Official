import 'dart:async';
import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var isTextEmpty = true.obs;

  void sendMessage(
      {String firebaseId, String message, String userId, String username}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .push()
        .set({
      "message": message,
      "userId": userId,
      "messageId": DateTime.now().toString(),
      "username": username
    });
  }

  Stream<Event> message({String firebaseId}) {
    final DatabaseReference firebasedatbase =
        FirebaseDatabase.instance.reference();

    firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .onChildAdded
        .listen((event) {
      print("Child added ${event.snapshot.value}");
    });

    // print('Test ${res.key}');

    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .startAt('1')
        .orderByChild('messageId')
        // .orderByChild("messageId")
        .onValue;
  }

  Stream<Event> test() {
    final DatabaseReference firebasedatbase =
        FirebaseDatabase.instance.reference();

    Stream<Event> result = firebasedatbase
        .child('Rooms')
        .child('MdppX3ZgzQKnJumJ75M')
        .child('chat')
        .orderByChild('messageId')
        // .orderByChild("messageId")
        .onValue;
    print("Check: ${result.toList()}");
  }

  Stream<QuerySnapshot> chatStream({String roomFireBaseId}) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc('$roomFireBaseId')
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  void sendMessageCloudFireStore(
      {String message, String roomId, String sentBy, String userId}) {
    FirebaseFirestore.instance
        // .collection(
        //     'personal_connections')  //${getxController.authData}/messages')
        .collection('chats')
        .doc('$roomId')
        .collection('messages')
        .add({
      'userId': userId,
      'message': message,
      'sentBy': sentBy,
      'timeStamp': DateTime.now().toUtc().millisecondsSinceEpoch,
    });
  }
}
