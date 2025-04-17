import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/buttons.dart';
import 'login_or_register.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginOrRegister()),
    ); // pushes you back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      // note: AppBar has a default return to prior screen so ElevatedButton below is redunant
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            MyButton(text: "Sign out", onTap: () => signOut(context)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("This is the Settings Page"),
            ),
          ],
        ),
      ),
    );
  }
}
