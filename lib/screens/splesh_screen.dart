import 'package:flutter/material.dart';

import '../auth/splesh_service.dart';

class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});
  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  SpleshService spleshService = SpleshService();
  @override
  void initState() {
    super.initState();
    spleshService.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(
            top: 30,
            left: 20,
            bottom: 30,
            right: 20,
          ),
          child: Image.asset("assets/images/chat.png"),
        ),
      ),
    );
  }
}
