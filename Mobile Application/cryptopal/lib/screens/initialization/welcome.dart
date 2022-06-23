import 'package:cryptopal/screens/registration_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'dashboard/dashboard_loading.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);
  static const String id = 'Welcome';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  void trySignIn() async{
    final _auth = FirebaseAuth.instance;
    final _functions = FirebaseFunctions.instance;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;

      if(_rememberMe){
        try {
          await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          try {
            HttpsCallable checkUser =
            _functions.httpsCallable('checkUser');
            final result =
            await checkUser.call(<String, dynamic>{
              'email': _email,
            });
            if (result.data.toString() == 'user') {
              Navigator.pushReplacementNamed(
                  context, DashboardLoading.id);
            } else {
              Navigator.pushReplacementNamed(
                  context, RegistrationForm.id);
            }
          } catch (e) {
            rethrow;
          }
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    trySignIn();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100.0,
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
                              style: kMainTitleStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                    child: Center(
                        child: GestureDetector(
                          child: const DefaultTextStyle(
                            style: kInstructionStyle,
                            child: Text(
                              'Advisory platform for cryptocurrency investments',
                              style: kInstructionStyle,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: kBackgroundColor,
                                  title: const Text(
                                    "CryptoPal",
                                    style: kTitleStyle,
                                  ),
                                  content: const Text(
                                    "CryptoPal is an advisory platform for cryptocurrency "
                                        "investments that only focused on educational purposes. "
                                        "\n\nPlease do not use this application as a advisor for "
                                        "financial investment purposes.",
                                    style: kInstructionStyle,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "OK",
                                        style: kLinkStyle,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: kAccentColor1,
                        borderRadius: const BorderRadius.all(Radius.zero),
                        onPressed: () {
                          Navigator.pushNamed(context, SignUp.id);
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
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: kAccentColor1,
                        borderRadius: const BorderRadius.all(Radius.zero),
                        onPressed: () {
                          Navigator.pushNamed(context, SignIn.id);
                        },
                        child: const Text(
                          'Sign in',
                          style: kButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  /*OutlinedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: SizedBox(
                      width: 70.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: kBaseColor2,
                          ),
                          Text(
                            ' Exit',
                            style: kInstructionStyle,
                          ),
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
