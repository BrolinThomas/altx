import 'package:altx/components/my_button.dart';
import 'package:altx/components/my_textfield.dart';
import 'package:altx/pages/loginpage.dart';
import 'package:altx/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUp extends ConsumerStatefulWidget {
  SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signUpKey = GlobalKey();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final RegExp emailValid = RegExp(
      r'^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$');

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _signUpKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
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
                  //Username textfield---------------------------------------------
                  MyTextField(
                      hintText: 'User Name',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 5) {
                          return 'Username must have atleast 5 characters';
                        }
                        return null;
                      },
                      controller: usernameController),
                  const SizedBox(
                    height: 10,
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
                  //confirm password textfield--------------------------------------
                  MyTextField(
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (passwordController.text !=
                            confirmPwController.text) {
                          return 'passwords do not match';
                        }
                        return null;
                      },
                      controller: confirmPwController),
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
                  //sign in button--------------------------------------------------
                  MyButton(
                    text: 'Sign Up',
                    onTap: () async {
                      if (_signUpKey.currentState!.validate()) {
                        try {
                          await _auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                          await ref
                              .read(userProvider.notifier)
                              .signUp(emailController.text);
                          if (!mounted) return;
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  //register button-------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
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
                                        LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return child;
                                },
                                transitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: const Text(
                            "Login here",
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
