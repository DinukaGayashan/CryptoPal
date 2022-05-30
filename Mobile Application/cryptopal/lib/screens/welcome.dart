import 'package:cryptopal/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);
  static const String id = 'Welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
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
                            child: Text(
                              'CryptoPal',
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
                      child: Text(
                        'Advisory platform for cryptocurrency investments',
                        style: kInstructionStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      color: kAccentColor1,
                      height:45.0,
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.pushNamed(context, SignUp.id);
                      },
                      child: const Text(
                        'Sign up',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      color: kAccentColor1,
                      height:45.0,
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.pushNamed(context, SignIn.id);
                      },
                      child: const Text(
                        'Sign in',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      color: kBaseColor2,
                    ),
                    onPressed: () {
                      Widget okButton = TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                      AlertDialog alert = AlertDialog(
                        backgroundColor: kBaseColor2,
                        title: const Text(
                          "CryptoPal",
                          style: kBlackTitleStyle,
                        ),
                        content: const Text(
                          "CryptoPal is an advisory platform for cryptocurrency "
                          "investments that only focused on educational purposes. "
                          "\n\nPlease do not use this as a advisor for financial investment purposes.",
                          style: kInstructionStyle2,
                        ),
                        actions: [
                          okButton,
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
