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
            ListView(
              children: <Widget>[
                topBar(context, 'About App'),
                const SizedBox(
                  height: 10.0,
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
                    DefaultTextStyle(
                      style: kTitleStyle,
                      child: Text(
                        'CryptoPal',
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height - 140,
                //   child: WebView(
                //     initialUrl: 'https://cryptopal-e288a.firebaseapp.com/AboutApp',
                //     javascriptMode: JavascriptMode.unrestricted,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "CryptoPal is an advisory platform for cryptocurrency investments that only focused on educational purposes.\n"
                      "\nPlease do not use this application as a advisor for financial investment purposes.",
                  style: kCardSmallTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: TextButton(
                    onPressed: (){},
                    child: Text(
                        'Policies & Conditions',
                      style: kLinkStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),





                const SizedBox(
                  height: 50,
                ),
                Center(
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
                  child: InkWell(
                    child:Text(
                      'Dinuka Gayashan',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'ReenieBeanie',
                        color: kBaseColor2,
                      ),
                    ),
                    onTap: () async {
                      await launch('https://dinukagayashan.github.io/_di-Website');
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
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
