import 'package:finance_app_flutter/home_page.dart';
import 'package:finance_app_flutter/registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String emailVal = "";
  String passwordVal = "";

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
                'Login Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                ),
              ),

              //Email Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0x7f3d3c4a),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xff777784)),
                ),
                margin: const EdgeInsets.fromLTRB(16, 48, 16, 16),
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
                        passwordController.text.isNotEmpty) {
                      buildShowDialog(context, true);
                      emailVal = emailController.text.toString();
                      passwordVal = passwordController.text.toString();

                      try {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: emailVal,
                          password: passwordVal,
                        )
                            .whenComplete(
                          () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (route) => false,
                              );
                            }
                          },
                        );
                      } on FirebaseAuthException catch (e) {
                        buildShowDialog(context, false);
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("No user found for that email."),
                          ));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Wrong password provided for that user."),
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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //CreateAccount
              Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Create Account',
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
