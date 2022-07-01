import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    child:  Text(
                      'Advisory platform for cryptocurrency investments',
                      style: kInstructionStyle,
                    ),
                  ),
                ),
                const Text(
                   about,
                    style: kInstructionStyle,
                ),
                const FaIcon(FontAwesomeIcons.instagram),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
