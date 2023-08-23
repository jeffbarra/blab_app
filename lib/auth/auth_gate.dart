import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home.dart';
import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // listens for changes in auth state
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
// If user IS logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
// If user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
