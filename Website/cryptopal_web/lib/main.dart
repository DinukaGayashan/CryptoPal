import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

void main() {
  runApp(const CryptoPalWeb());
}

class CryptoPalWeb extends StatelessWidget {
  const CryptoPalWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CryptoPal-Web",
      theme: ThemeData.dark().copyWith(
        primaryColor: kBaseColor1,
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
        body: Column(
      children: <Widget>[
        Hero(
                tag: 'logo',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 100.0,
                  child: Image.asset('assets/images/CryptoPal-logo-white.png'),
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
    ));
  }
}
