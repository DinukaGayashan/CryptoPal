import 'package:flutter/material.dart';
import 'constants.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: AppBar(
        backgroundColor: kAccentColor1,
        elevation: 0.0,
        toolbarHeight: 80.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: kAccentColor1,
              radius: 25.0,
              child: Image.asset('assets/images/CryptoPal-logo-black.png'),
            ),
            const Text(
              "CryptoPal",
              style: kTitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
