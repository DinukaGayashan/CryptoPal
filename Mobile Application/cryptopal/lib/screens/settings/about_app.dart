import 'package:cryptopal/screens/settings/logo_page.dart';
import 'package:cryptopal/screens/settings/privacy_policy.dart';
import 'package:cryptopal/screens/settings/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:share_plus/share_plus.dart';
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                topBar(context, 'About App'),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Row(
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
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const LogoPage();
                            }));
                      },
                    ),
                    const Text(
                      'Version 0.9',
                      style: kTransparentSmallStyle,
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
                      child: Text(
                        "CryptoPal is an advisory platform for cryptocurrency investments that only focused on educational purposes. "
                            "Please do not use this application as a advisor for financial investment purposes.",
                        style: kCardSmallTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 130,
                    child:TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.share_rounded,
                            size: 18,
                            color: kBaseColor2,
                          ),
                          SizedBox(width: 10,),
                          Text(
                              'Share App',
                            style: kCardSmallTextStyle,
                          )
                        ],
                      ),
                      onPressed: () async {
                        await Share.shareWithResult('https://cryptopal-e288a.web.app');
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, PrivacyPolicy.id);
                    },
                    child: const Text(
                        'Privacy Policy',
                      style: kLinkStyle,
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, TermsConditions.id);
                    },
                    child: const Text(
                      'Terms & Conditions',
                      style: kLinkStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height-600,
                ),
                Column(
                  children: [
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
