import 'package:blab/components/chat_bubble.dart';
import 'package:blab/components/message_textfield.dart';
import 'package:blab/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
// Text Controller
  final TextEditingController _messageController = TextEditingController();

// Chat Service
  final ChatService _chatService = ChatService();

// Get instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// Send Message Method
  void sendMessage() async {
    // if message controller has content
    if (_messageController.text.isNotEmpty) {
      // sendMessage method from ChatService
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
      // clear controller after message send
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

// App Bar
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.receiverUserEmail,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ),

// Body
        body: Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
            ),

            // user posts
            _buildMessageInput(),
          ],
        ));
  }

// build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          // error handler
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          // if loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          // for each doc (message) -> build message item (_buildMessageItem) -> return as list
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

// build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages based on the sender (sender = the current user -> align to right)
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Build the message using conditions above
    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // cross align based on sender
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            // main align based on sender
            mainAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(data['senderEmail'],
                    style: const TextStyle(color: Colors.grey)),
              ),

              const SizedBox(height: 6),

              // chat bubble widget we created
              ChatBubble(
                  message: data['message'],
                  // chat bubble border radius based on user
                  borderRadius:
                      (data['senderId'] == _firebaseAuth.currentUser!.uid)
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50))
                          : const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                  // color based on user
                  color: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? Theme.of(context).primaryColor
                      : Colors.black),
            ],
          ),
        ));
  }

// build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0, right: 20.0, left: 20.0),
      child: Row(
        children: [
          // message field
          Expanded(
            child: MessageTextField(
                controller: _messageController,
                hintText: "Enter message...",
                obscureText: false),
          ),

          // send button
          IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: Icon(Icons.arrow_circle_up,
                  color: Theme.of(context).primaryColor, size: 40)),
        ],
      ),
    );
  }
}
