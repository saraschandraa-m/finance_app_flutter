import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app_flutter/home_page.dart';
import 'package:finance_app_flutter/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool passwordVisible = false;

  String emailVal = "";
  String passwordVal = "";
  String userNameVal = "";
  String phoneVal = "";

  @override
  void initState() {
    passwordVisible = true;
    super.initState();
  }

  buildShowDialog(BuildContext context, bool show) {
    return showDialog(
        context: context,
        barrierDismissible: show,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Create new Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                ),
              ),

              //UserName Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x7f3d3c4a),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xff777784)),
                ),
                margin: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                child: TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.white60,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Username",
                    contentPadding: EdgeInsets.only(
                        left: 16, bottom: 16, top: 16, right: 16),
                    suffixIcon: Icon(Icons.person),
                  ),
                ),
              ),

              //Email Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x7f3d3c4a),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xff777784)),
                ),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.white60,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    contentPadding: EdgeInsets.only(
                        left: 16, bottom: 16, top: 16, right: 16),
                    suffixIcon: Icon(Icons.mail),
                  ),
                ),
              ),

              //Phone Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x7f3d3c4a),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xff777784)),
                ),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.white60,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone Number",
                    contentPadding: EdgeInsets.only(
                        left: 16, bottom: 16, top: 16, right: 16),
                    suffixIcon: Icon(Icons.phone),
                  ),
                ),
              ),

              //Password Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x7f3d3c4a),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xff777784)),
                ),
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Colors.white60,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    contentPadding: const EdgeInsets.only(
                        left: 16, bottom: 16, top: 16, right: 16),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)),
                  ),
                ),
              ),

              //SignIn Button
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0)),
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty &&
                        userNameController.text.isNotEmpty) {
                      buildShowDialog(context, true);
                      emailVal = emailController.text.toString();
                      passwordVal = passwordController.text.toString();
                      phoneVal = phoneController.text.toString();
                      userNameVal = userNameController.text.toString();

                      try {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailVal, password: passwordVal)
                            .whenComplete(() {
                          User currentUser = FirebaseAuth.instance.currentUser!;

                          HashMap<String, String> newUser = HashMap();
                          newUser['username'] = userNameVal;
                          newUser['email'] = emailVal;
                          newUser['phone'] = phoneVal;

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(currentUser.uid)
                              .set(newUser)
                              .whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false,
                            );
                          });
                        });
                      } on FirebaseAuthException catch (e) {
                        buildShowDialog(context, false);
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("The password provided is too weak."),
                          ));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "The account already exists for that email."),
                          ));
                        }
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //Login
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
