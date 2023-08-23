import 'package:blab/auth/auth_service.dart';
import 'package:blab/components/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../components/my_textfield.dart';
import '../../widgets/buttons/google_button.dart';
import '../../widgets/buttons/login_register_button.dart';
import '../../widgets/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onPressed;
  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Editing Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

// Sign User In
  void signIn() async {
    // get instance of auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    // show loading circle
    showDialog(
        context: context,
        builder: (context) => Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor)));
    // try login user using email controller and password controller values
    try {
      await authService.signInWithEmailAndPassword(
          emailTextController.text, passwordTextController.text);

      // if login is successful -> pop loading circle
      if (context.mounted) Navigator.pop(context);

      // if error -> show snackbar with error
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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

            // Login Image
            Image.asset('lib/assets/images/login.png', width: 300),

            // Welcome Back Text
            const Text('Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            const SizedBox(height: 40),

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

            // Password Textfield
            PasswordTextField(controller: passwordTextController),

            // Forgot Password Link
            const ForgotPasswordFooter(),

            // Sign In Button
            LoginRegisterButton(text: 'Login', onPressed: signIn),

            const SizedBox(
              height: 20,
            ),

            // Google Button
            GoogleAuthButton(text: 'Sign In with Google', onPressed: () {}),

            const SizedBox(height: 20),

            // Go to Register Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black)),
                TextButton(
                    onPressed: widget.onPressed,
                    child: Text('Register now',
                        style: TextStyle(
                            color: Colors.pink.shade300,
                            fontWeight: FontWeight.w600))),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
