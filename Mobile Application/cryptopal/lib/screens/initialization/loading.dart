import 'dart:io';

import 'package:cryptopal/screens/initialization/registration_form.dart';
import 'package:cryptopal/screens/initialization/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);
  static const String id = 'Loading';

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

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
      else{
        Navigator.pushReplacementNamed(
            context, Welcome.id);
      }
    } catch (e) {
      rethrow;
    }
  }

  void checkConnection()async{
    try{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        trySignIn();
      }
    }catch(e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kBackgroundColor,
            title: const Text(
              'Connection Error',
              style: kInstructionStyle2,
            ),
            content: const Text(
              "Check your connection and retry.",
              style: kInstructionStyle,
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Retry",
                  style: kLinkStyle,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(
                      context, Loading.id);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkConnection();

    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 100.0,
                      child:
                      Image.asset('assets/images/CryptoPal-logo-white.png'),
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
              const SizedBox(
                height: 50.0,
                child: Center(
                  child: Hero(
                    tag: 'description',
                    child: DefaultTextStyle(
                      style: kInstructionStyle,
                    child: Text(
                      'Advisory platform for cryptocurrency investments',

                    ),
                  ),),
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              const SizedBox(
                child: SpinKitFoldingCube(
                  size: 50.0,
                  color: kBaseColor2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
