import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/textfields.dart';
import '../components/buttons.dart';
import 'foundation.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final void Function()? onTap;

  final pwTestPattern = RegularExpressionPatterns.passwordPattern();
  final emailTestPattern = RegularExpressionPatterns.emailPattern();
  final pwRequirements = RegularExpressionPatterns.passwordRequirements();

  LoginPage({super.key, required this.onTap});

  // THIS IS REDUNDANT GET IT INTO ANOTHER FILE
  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
  }

  void login(BuildContext context) async {
    if (!emailTestPattern.hasMatch(emailController.text)) {
      displayMessageToUser("Invalid email address", context);
    } else if (!pwTestPattern.hasMatch(pwController.text)) {
      displayMessageToUser(pwRequirements, context);
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: pwController.text,
        );
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
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyButton(text: "LogIn", onTap: () => login(context)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?  "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register Here",
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
