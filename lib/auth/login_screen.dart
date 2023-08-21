import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gapshap/widget/user_image_picker.dart';

import '../screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late String useremailAddress = '';
  late String userPassword = '';
  late String enterUserName = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameConrrroller = TextEditingController();
  var _isLogin = true;
  File? _selectedImage;
  var isAuthenticaton = false;

  void isSaved() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();
    if (_isLogin) {
      login();
    } else {
      signUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  right: 20,
                  left: 20,
                ),
                width: 200,
                child: Image.asset(
                  "assets/images/chat.png",
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickedImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            autocorrect: true,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: "Enter Username",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains("@")) {
                                return "Please Enter valid Email.";
                              }
                              return null;
                            },
                            onSaved: (email) {
                              useremailAddress = email.toString();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Enter at least 4 cahracters.";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enterUserName = newValue!;
                              },
                              controller: _userNameConrrroller,
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                hintText: "Enter Password",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.security)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length <= 7) {
                                return "Enter valid password.";
                              }
                              return null;
                            },
                            onSaved: (password) {
                              userPassword = password.toString();
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (isAuthenticaton)
                            const CircularProgressIndicator(),
                          if (!isAuthenticaton)
                            ElevatedButton.icon(
                              onPressed: isSaved,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 64, 148, 190)),
                              icon: Icon(
                                _isLogin ? Icons.login : Icons.login_outlined,
                                color: Colors.white,
                              ),
                              label: Text(
                                _isLogin ? "Login" : "Sign Up",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (!isAuthenticaton)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? "Don't have an Account?"
                                    : "Already have an account.",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        isAuthenticaton = true;
      });
      await auth
          .signInWithEmailAndPassword(
              email: useremailAddress, password: userPassword)
          .then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Up Done "),
          duration: Duration(seconds: 3),
        ));
      }).onError((error, stackTrace) {});
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        key: _scaffoldMessengerKey,
        content: Text("Login is not Done BCz ${e.toString()}"),
        duration: const Duration(seconds: 3),
      ));
    }
    setState(() {
      isAuthenticaton = false;
    });
  }

  void signUp() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        isAuthenticaton = true;
      });
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: useremailAddress,
        password: userPassword,
      );
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${userCredential.user!.uid}.jpg");
      await storageRef.putFile(_selectedImage!);
      final imageURL = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user!.uid)
          .set(({
            'username': enterUserName,
            'email': useremailAddress,
            'imageURL': imageURL
          }));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign Up Done "),
        duration: Duration(seconds: 3),
      ));
      setState(() {
        _emailController.clear();
        _passwordController.clear();
        _isLogin = !_isLogin;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("SignUp is not Done BCz ${error.toString()}"),
        duration: const Duration(seconds: 3),
      ));
    }
    setState(() {
      isAuthenticaton = false;
    });
  }
}
