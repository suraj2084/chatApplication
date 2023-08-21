import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap/auth/login_screen.dart';
import 'package:gapshap/screens/home_screen.dart';

class SpleshService {
  final _auth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
      });
    }
  }
}
