import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cryptopal/utility/constants.dart';

class add_prediction extends StatefulWidget {
  const add_prediction({Key? key}) : super(key: key);
  static const String id='add_prediction';

  @override
  State<add_prediction> createState() => _add_predictionState();
}

class _add_predictionState extends State<add_prediction> {
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
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                backgroundColor: kAccentColor1,
                radius: 25.0,
                child: Image.asset('assets/images/CryptoPal-logo-black.png'),
              ),
            ),
            const Hero(
              tag: 'name',
              child: Text(
                "CryptoPal",
                style: kTitleStyle,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now().add(const Duration(days:1)),
                    minimumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime value) {

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
