import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class welcome extends StatelessWidget {
  const welcome({Key? key}) : super(key: key);
  static const String id='welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 100.0,
                        child: Image.asset('assets/images/CryptoPal-logo-black.png'),
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
                  height: 100.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: MaterialButton(
                    color: kBaseColor1,
                    height:40.0,
                    minWidth: double.infinity,
                    onPressed: () {
                      Navigator.pushNamed(context, sign_up.id);
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
                    color: kBaseColor1,
                    height:40.0,
                    minWidth: double.infinity,
                    onPressed: () {
                      Navigator.pushNamed(context, sign_in.id);
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
                    color: kBaseColor1,
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
                          style: kTitleStyle,
                        ),
                        content: const Text(
                          "CryptoPal is an advisory platform for cryptocurrency "
                              "investments that only focused on educational purposes. "
                              "\n\nPlease do not use this as a advisor for investment purposes.",
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
        ),
      ),
    );
  }
}
