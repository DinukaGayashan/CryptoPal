import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/screens/initialization/sign_in.dart';
import 'package:cryptopal/screens/initialization/sign_up.dart';

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
                                return CupertinoAlertDialog(
                                  title: const Text(
                                    "CryptoPal\n",
                                    style: kTitleStyle,
                                  ),
                                  content: const Text(
                                    about,
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
                        ),),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: kAccentColor1,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: kAccentColor1,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                    height: 60.0,
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
