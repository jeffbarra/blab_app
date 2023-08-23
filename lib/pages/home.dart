import 'package:blab/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Instance of Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Sign User Out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    // sign user out
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// AppBar
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.pink.shade300,
          // logo
          title: Text('blab',
              style: GoogleFonts.cherryCreamSoda(
                  fontSize: 40, color: Colors.white)),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              // logout button
              child: IconButton(
                onPressed: () {
                  signOut();
                },
                icon: const Icon(Icons.logout, size: 30),
              ),
            )
          ],
        ),

// Body
        body: _buildUserList());
  }

// Build a list of users except for the current logged in user
  Widget _buildUserList() {
    // stream builder of ONLY query snapshots
    return StreamBuilder<QuerySnapshot>(
        // get collection of users
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // error handler
          if (snapshot.hasError) {
            return const Text('error');
          }
          // if loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }

          // create list of all docs in firestore -> build a user list item
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

// build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // if email of current user is NOT in list
    if (_auth.currentUser!.email != data['email']) {
      // return list tile of all other users email
      return Padding(
        padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.pink.shade300),
              borderRadius: BorderRadius.circular(20),
              color: Colors.pink.shade100),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.black),
              trailing: const Icon(Icons.arrow_forward, color: Colors.black),
              title: Text(
                data['email'],
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // when user clicks on user's email -> go to that chat page
                Get.to(() => ChatPage(
                      receiverUserEmail: data['email'],
                      receiverUserId: data['uid'],
                    ));
              },
            ),
          ),
        ),
      );
    } else {
      // return empty container
      return Container();
    }
  }
}
