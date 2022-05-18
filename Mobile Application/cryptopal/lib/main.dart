import 'package:cryptopal/constants.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'sign_in.dart';
import 'registration_form.dart';

void main() {
  runApp(const CryptoPal());
}

class CryptoPal extends StatelessWidget {
  const CryptoPal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CryptoPal",
      theme: ThemeData.dark().copyWith(
        primaryColor: kBaseColor1,
        scaffoldBackgroundColor: kAccentColor1,
      ),
      initialRoute: '/registration_form',
      routes: {
        '/sign_up': (context) => sign_up(),
        '/sign_in': (context) => sign_in(),
        '/registration_form': (context) => registration_form(),
        /*
        '/settings': (context) => settings(),
        */
      },
    );
  }
}
