import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/textfields.dart';
import '../components/buttons.dart';
import 'foundation.dart';

// import '../models/book_model.dart';
// import '../services/googleapi_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwconfirmController = TextEditingController();
  final void Function()? onTap;

  final pwTestPattern = RegularExpressionPatterns.passwordPattern();
  final emailTestPattern = RegularExpressionPatterns.emailPattern();
  final pwRequirements = RegularExpressionPatterns.passwordRequirements();

  RegisterPage({super.key, required this.onTap});

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
  }

  void registerUser(BuildContext context) async {
    if (!emailTestPattern.hasMatch(emailController.text)) {
      displayMessageToUser("Invalid email address", context);
    } else if (!pwTestPattern.hasMatch(pwController.text)) {
      displayMessageToUser(pwRequirements, context);
    } else if (pwController.text != pwconfirmController.text) {
      displayMessageToUser("Passwords don't match!", context);
    } else {
      // displayMessageToUser("All is good!", context);
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: pwController.text,
            );
        createUserDocument(userCredential);
        Navigator.of(
          // ignore: use_build_context_synchronously
          context,
        ).push(MaterialPageRoute(builder: (context) => const FoundationPage()));
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              const SizedBox(height: 5),
              Text("T E A C H E R", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: pwController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: pwconfirmController,
              ),
              const SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Text(
              //       "Forgot Password?",
              //       style: TextStyle(
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              MyButton(text: "Register", onTap: () => registerUser(context)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?  "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
