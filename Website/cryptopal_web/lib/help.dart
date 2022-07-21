import 'package:cryptopal_web/widgets.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: background(context,
        SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
                children: <Widget>[
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: <Widget>[
                  //     CircleAvatar(
                  //       backgroundColor: Colors.transparent,
                  //       radius: 25.0,
                  //       child: Image.asset(
                  //           'assets/images/CryptoPal-logo-white.png'),
                  //     ),
                  //     const DefaultTextStyle(
                  //       style: kTitleStyle,
                  //       child: Text(
                  //         'CryptoPal',
                  //       ),
                  //     ),
                  //   ],
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
                          'Policies & Conditions'
                        ),
                    ),
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
                      onTap: (){
                        html.window.open('https://dinukagayashan.github.io/_di-Website', 'new tab');
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){
                            html.window.open('https://www.facebook.com/DinukaGayashan.di', 'new tab');
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.facebookF,
                            size: 15,
                          )
                      ),
                      IconButton(
                          onPressed: (){
                            html.window.open('https://www.linkedin.com/in/dinukagayashan/', 'new tab');
                          },
                          icon: FaIcon(
                              FontAwesomeIcons.linkedinIn,
                            size: 15,
                          )
                      ),
                      IconButton(
                          onPressed: (){
                            html.window.open('https://twitter.com/Dinuka_Gayashan', 'new tab');
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 15,
                          )
                      ),
                      IconButton(
                          onPressed: (){
                            html.window.open('https://www.instagram.com/dinuka.di/', 'new tab');
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.instagram,
                            size: 15,
                          )
                      ),
                      IconButton(
                          onPressed: (){
                            html.window.open('https://github.com/DinukaGayashan', 'new tab');
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.github,
                            size: 15,
                          )
                      ),
                    ],
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
