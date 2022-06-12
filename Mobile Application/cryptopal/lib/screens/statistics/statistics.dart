import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Statistics extends StatefulWidget {
  const Statistics(this.currentUser, {Key? key}) : super(key: key);

  static const String id = 'Statistics';
  final UserAccount currentUser;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Statistics'),
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    'Cryptocurrency Prediction Accuracy',
                    style: kCardSmallTextStyle,
                  ),
                ),
                const SizedBox(height: 15.0,),
                SfLinearGauge(
                  minimum: 0,
                  maximum: 100,
                  //showLabels: false,
                  //showTicks: false,
                  showAxisTrack: false,
                  isMirrored: true,
                  barPointers: [
                    for(int i=0;i<cryptocurrencies.length;i++)
                      LinearBarPointer(
                        thickness: 25.0,
                        enableAnimation: true,
                        //animationDuration: kAnimationTime,
                        value: (currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble(),
                        color: ((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs())>50?kGreen:kRed,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        offset: i*30+35,
                        position: LinearElementPosition.outside,
                        child: Center(
                          child: Text(
                            cryptocurrencies[i]+' '+((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble()).toString()+'%',
                            style: kCardSmallTextStyle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
