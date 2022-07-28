import 'package:cryptopal_web/help.dart';
import 'package:cryptopal_web/home_page.dart';
import 'package:cryptopal_web/share_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const CryptoPalWeb());
}

class CryptoPalWeb extends StatelessWidget {
  const CryptoPalWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CryptoPal-Web",
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/Help': (context) => const Help(),
        '/ShareApp': (context) => const ShareApp(),
      },
    );
  }
}


