import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gapshap/auth/login_screen.dart';
import 'package:gapshap/widget/chat_message.dart';
import 'package:gapshap/widget/new_chat_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void pushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print(token);
  }

  @override
  void initState() {
    super.initState();
    pushNotification();
  }

  final auth = FirebaseAuth.instance;
  void signOut() {
    auth.signOut().then((value) {
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign Out Done "),
        duration: Duration(seconds: 3),
      ));
    });
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("GapShap"),
          actions: [
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
          ],
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewChatMessage(),
          ],
        ));
  }
}
