import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gapshap/screens/splesh_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: const SpleshScreen(),
      // StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (ctx, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         Timer(const Duration(seconds: 3), () {
      //           const SpleshScreen();
      //         });
      //       }
      //       if (snapshot.hasData) {
      //         return const HomeScreen();
      //       } else {
      //         return const SpleshScreen();
      //       }
      //     }));
    );
  }
}
