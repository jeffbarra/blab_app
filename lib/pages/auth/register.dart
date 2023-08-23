import 'package:blab/auth/auth_service.dart';
import 'package:blab/components/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../components/my_textfield.dart';
import '../../widgets/buttons/google_button.dart';
import '../../widgets/buttons/login_register_button.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onPressed;
  const SignUpPage({super.key, required this.onPressed});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
// Text Editing Controllers
  final fullNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

// Sign User Up
  signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
    );

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    // try signing the user up
    try {
      // sign user up using values within the controllers
      await authService.signUpWithEmailAndPassword(
          emailTextController.text, passwordTextController.text);

      // if successful -> pop loading circle
      if (context.mounted) Navigator.pop(context);

      // if error -> display error within snackbar
    } catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // display error message in snackbar
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('blab',
                    style: GoogleFonts.cherryCreamSoda(
                        fontSize: 60, color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
          // Welcome Image
          Image.asset(
            'lib/assets/images/register.png',
            width: 300,
          ),

          // Welcome Back Message
          const Text('Hello There!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),

          const SizedBox(
            height: 40,
          ),

          // Email Textfield
          MyTextField(
            controller: fullNameTextController,
            hintText: 'Enter Name',
            obscureText: false,
            prefixIcon: Icons.person,
          ),

          const SizedBox(
            height: 10,
          ),

          // Email Textfield
          MyTextField(
            controller: emailTextController,
            hintText: 'Enter Email',
            obscureText: false,
            prefixIcon: Icons.email,
          ),

          const SizedBox(
            height: 10,
          ),

          //  Password Textfield
          PasswordTextField(
            controller: passwordTextController,
          ),

          const SizedBox(height: 20),

          // Sign Up Button
          LoginRegisterButton(text: 'Sign Up', onPressed: signUp),

          const SizedBox(
            height: 20,
          ),

          // Google Button
          GoogleAuthButton(text: 'Sign Up with Google', onPressed: () {}),

          const SizedBox(height: 20),

          // Go to Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black)),
              TextButton(
                  onPressed: widget.onPressed,
                  child: Text('Login now',
                      style: TextStyle(
                          color: Colors.pink.shade300,
                          fontWeight: FontWeight.w600))),
            ],
          )
        ],
      ),
    )));
  }
}
