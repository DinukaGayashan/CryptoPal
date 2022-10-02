import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({Key? key}) : super(key: key);

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  double radius = 200;
  Color fillColor = kUserColorMap[Random().nextInt(kUserColorMap.length)];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          setState(() {
            fillColor = kUserColorMap[Random().nextInt(kUserColorMap.length)];
          });
        },
        onLongPress: () {
          Navigator.pop(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.ease,
          color: fillColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: AnimatedContainer(
                  width: radius,
                  height: radius,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child:
                        Image.asset('assets/images/CryptoPal-logo-white.png'),
                  ),
                ),
                onTap: () {
                  setState(() {
                    radius = radius > 200 ? 200 : 300;
                  });
                },
              ),
              const SizedBox(
                height: 50.0,
                width: double.infinity,
                child: Center(
                  child: DefaultTextStyle(
                    style: kMainTitleStyle,
                    child: Text(
                      'CryptoPal',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
