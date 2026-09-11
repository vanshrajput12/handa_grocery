import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../bottom Nav/Bottom_Nav.dart';
import 'auth_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Firebase is checking authentication
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          return const BottomNav();
        }

        // User is logged out
        return const AuthPage();
      },
    );
  }
}