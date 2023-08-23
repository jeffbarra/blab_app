import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info (id, email, timestamp)
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // construct chat room ID from current user id and receiver id (sorted)
    // get id of 2 people (sender and receiver) -> as a list and then sort them
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for an pair of users)
    String chatRoomId = ids.join(
        '_'); // combine the ids into a single string to use as a chatroomID

    // Create a new collection called "chat_rooms"
    // Create a sub-collection called "messages"
    // Add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

// Get Message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room Id from user Ids (sorted to ensure it matches the id used when sending)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');

    // return 'messages' within the collection 'chat_rooms' based on chatRoomID -> sorted by timestamp
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
