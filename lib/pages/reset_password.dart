import 'package:blab/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
// Email Controller
  final _emailController = TextEditingController();

// Memory management
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Reset Password',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Image(
                image: AssetImage(
                  'lib/assets/images/email_otp.png',
                ),
                width: 300,
              ),
            ),

// Instructions
            const Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                'Enter your email address and we will send you a link to reset your password.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

// Form Field
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  MyTextField(
                      controller: _emailController,
                      hintText: 'Enter email',
                      obscureText: false,
                      prefixIcon: Icons.email),

                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
