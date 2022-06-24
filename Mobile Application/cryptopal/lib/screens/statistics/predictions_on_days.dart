import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class PredictionsOnDays extends StatefulWidget {
  const PredictionsOnDays({Key? key}) : super(key: key);

  @override
  State<PredictionsOnDays> createState() => _PredictionsOnDaysState();
}

class _PredictionsOnDaysState extends State<PredictionsOnDays> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Predictions On Days'),
                const SizedBox(
                  height: 10.0,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
