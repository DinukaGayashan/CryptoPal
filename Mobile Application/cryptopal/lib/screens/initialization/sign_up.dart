import 'package:cryptopal/utility/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cryptopal/screens/initialization/sign_in.dart';
import 'package:cryptopal/screens/initialization/registration_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String id = 'SignUp';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  late String email = '', password1 = '', password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          child: Image.asset(
                              'assets/images/CryptoPal-logo-white.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: Center(
                          child: Hero(
                            tag: 'name',
                            child: DefaultTextStyle(
                              child: Text(
                                'CryptoPal',
                              ),
                              style: kTitleStyle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      const SizedBox(
                        height: 60.0,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Sign up',
                            style: kSubjectStyle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          style: kInstructionStyle,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Enter email',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: InputBorder.none,
                            fillColor: kTransparentColor1,
                            filled: true,
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          style: kInstructionStyle,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Enter password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: InputBorder.none,
                            fillColor: kTransparentColor1,
                            filled: true,
                          ),
                          onChanged: (value) {
                            password1 = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 9.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          style: kInstructionStyle,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Re-enter password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: InputBorder.none,
                            fillColor: kTransparentColor1,
                            filled: true,
                          ),
                          onChanged: (value) {
                            password2 = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: CupertinoButton(
                            color: kAccentColor1,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            onPressed: () async {
                              if (password1.length < 6) {
                                snackBar(context,
                                    message:
                                        'Password must contain at least 6 characters.',
                                    color: kRed);
                              } else if (password1 == password2) {
                                try {
                                  final user = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password1);
                                  Navigator.pushReplacementNamed(
                                      context, RegistrationForm.id);
                                } catch (e) {
                                  snackBar(context,
                                      message: e.toString(), color: kRed);
                                  //snackBar(context,message: e.toString().split(']').removeLast(),color: kRed);
                                }
                              } else {
                                snackBar(context,
                                    message: 'Passwords are not similar.',
                                    color: kRed);
                              }
                            },
                            child: const Text(
                              'Sign up',
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Already have an account?',
                              style: kInstructionStyle,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: kInstructionStyle,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, SignIn.id);
                              },
                              child: const Text(
                                'Sign in',
                                style: kLinkStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
