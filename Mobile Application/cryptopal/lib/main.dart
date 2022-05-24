import 'package:cryptopal/screens/add_prediction.dart';
import 'package:cryptopal/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utility/constants.dart';
import 'screens/sign_up.dart';
import 'screens/sign_in.dart';
import 'screens/registration_form.dart';
import 'screens/dashboard_loading.dart';
import 'screens/add_prediction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: dashboard_loading.id,
      routes: {
        welcome.id: (context) => const welcome(),
        sign_up.id: (context) => const sign_up(),
        sign_in.id: (context) => const sign_in(),
        registration_form.id: (context) => const registration_form(),
        dashboard_loading.id: (context) => const dashboard_loading(),
        //dashboard.id: (context) => dashboard(),
        add_prediction.id: (context) => const add_prediction(),
      },
    );
  }
}
