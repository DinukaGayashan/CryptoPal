import 'package:flutter/material.dart';
import 'constants.dart';

class ShareApp extends StatelessWidget {
  const ShareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kTransparentColor8,
        body: ListView(
          children: const [
            Center(
              child: Text(
                'App is currently at beta release',
              style: kCardSmallTextStyle,
              ),
            )
          ],
        ),
    );
  }
}
