import 'package:blab/auth/auth_gate.dart';
import 'package:blab/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'auth/auth_service.dart';

void main() async {
  // initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // wrap in Change Notifier Provider
  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.pink.shade300,
          onPrimary: Colors.black, // Text on primary color
          background: Colors.black,
          onSecondary: Colors.black,
          error: Colors.red,
          onBackground: Colors.black,
          onError: Colors.pink.shade200,
          onSurface: Colors.black, // colors for text fields
          secondary: Colors.black,
          surface: Colors.grey.shade200,

          // colors for widgets
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primaryColor: Colors.pink.shade300,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const AuthGate(),
    );
  }
}
