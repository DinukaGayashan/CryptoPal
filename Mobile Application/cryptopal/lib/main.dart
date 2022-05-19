import 'package:cryptopal/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'utility/constants.dart';
import 'screens/sign_up.dart';
import 'screens/sign_in.dart';
import 'screens/registration_form.dart';
import 'screens/dashboard.dart';

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
      initialRoute: sign_up.id,
      routes: {
        welcome.id: (context) => welcome(),
        sign_up.id: (context) => sign_up(),
        sign_in.id: (context) => sign_in(),
        registration_form.id: (context) => registration_form(),
        dashboard.id: (context) => dashboard(),
      },
    );
  }
}
