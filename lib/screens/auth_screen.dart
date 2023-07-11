import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_task/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void submitAuthForm(
      {required String email,
      required String username,
      required String password,
      required bool isLogin}) async {
    try {
      UserCredential userCredential;
      if (isLogin) {
        // login
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        // register
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'username': username,
            'email': email,
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      var messege = e.message ?? "Silahkan Periksa Kembali Data Anda";

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messege),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Text("MyTask"),
                const SizedBox(height: 25),
                AuthForm(submitAuthFormFn: submitAuthForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
