import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            Column(
              children: <Widget>[
                topBar(context, 'About App'),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 25.0,
                      child: Image.asset(
                          'assets/images/CryptoPal-logo-white.png'),
                    ),
                    const Text(
                        'CryptoPal',
                        style: kTitleStyle,
                      ),
                  ],
                ),
                const Text(
                  'Version 0.9',
                  style: kTransparentSmallStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "CryptoPal is an advisory platform for cryptocurrency investments that only focused on educational purposes. "
                        "Please do not use this application as a advisor for financial investment purposes.",
                    style: kCardSmallTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: TextButton(
                    onPressed: (){
                      snackBar(context, message: 'No Terms, No Conditions ;-)', color: kGreen);
                    },
                    child: const Text(
                        'Terms & Conditions',
                      style: kLinkStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),





                ListTile(title: Text('Share App'),),
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: Text(
                    'DEVELOPER',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Bierstadt',
                      color: kTransparentColor3,
                      letterSpacing: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    child:const Text(
                      'Dinuka Gayashan',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'ReenieBeanie',
                        color: kBaseColor2,
                      ),
                    ),
                    onTap: () async {
                      await launch('https://dinukagayashan.github.io/_di-Website');
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
