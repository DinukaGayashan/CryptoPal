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
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      initialRoute: DashboardLoading.id,
      routes: {
        Welcome.id: (context) => const Welcome(),
        SignUp.id: (context) => const SignUp(),
        SignIn.id: (context) => const SignIn(),
        RegistrationForm.id: (context) => const RegistrationForm(),
        DashboardLoading.id: (context) => const DashboardLoading(),
        //AddPrediction.id: (context) => const AddPrediction(),
      },
    );
  }
}
