import 'package:altx/components/my_button.dart';
import 'package:altx/components/my_textfield.dart';
import 'package:altx/pages/signuppage.dart';
import 'package:altx/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _logInKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r'^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _logInKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  //logo------------------------------------------------------------
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 25),
                  //app name--------------------------------------------------------
                  const Text(
                    'A L T X',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //email textfield-------------------------------------------------
                  MyTextField(
                      hintText: 'Email',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (value.length < 6) {
                          return 'Please enter a valid email';
                        } //Regular Expression
                        else if (!emailValid.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      controller: emailController),
                  const SizedBox(
                    height: 10,
                  ),

                  //password textfield----------------------------------------------
                  MyTextField(
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6) {
                          return 'password must have atleast 6 characters';
                        }
                        return null;
                      },
                      controller: passwordController),
                  const SizedBox(
                    height: 10,
                  ),

                  //forgot password-------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  //Register--------------------------------------------------------
                  MyButton(
                    text: 'Login',
                    onTap: () async {
                      if (_logInKey.currentState!.validate()) {
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                          ref
                              .read(userProvider.notifier)
                              .login(emailController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 25),

                  //Login button----------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        SignUp(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child;
                                },
                                transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: const Text(
                            "Register here",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
