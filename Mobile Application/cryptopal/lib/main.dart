import 'package:cryptopal/screens/settings/privacy_policy.dart';
import 'package:cryptopal/screens/settings/terms_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/screens/initialization/loading.dart';
import 'package:cryptopal/screens/initialization/welcome.dart';
import 'package:cryptopal/screens/initialization/sign_up.dart';
import 'package:cryptopal/screens/initialization/sign_in.dart';
import 'package:cryptopal/screens/initialization/registration_form.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';

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
        useMaterial3: true,
        primaryColor: kBaseColor1,
        scaffoldBackgroundColor: kBackgroundColor,
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: kInstructionStyle2,
            pickerTextStyle: kInstructionStyle2,
          ),
        ),
      ),
      initialRoute: Loading.id,
      routes: {
        Loading.id: (context) => const Loading(),
        Welcome.id: (context) => const Welcome(),
        SignUp.id: (context) => const SignUp(),
        SignIn.id: (context) => const SignIn(),
        RegistrationForm.id: (context) => const RegistrationForm(),
        PrivacyPolicy.id: (context) => const PrivacyPolicy(),
        TermsConditions.id: (context) => const TermsConditions(),
        DashboardLoading.id: (context) => const DashboardLoading(),
      },
    );
  }
}
