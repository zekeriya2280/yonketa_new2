import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yonketa_new/pages/Intro.dart';
import 'package:yonketa_new/pages/menupage.dart';

class Wrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return const MenuPage();
          } else {
            // User is not signed in
            return const IntroPage();
          }
        }
      },
    );
  }
}