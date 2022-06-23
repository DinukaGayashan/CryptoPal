import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Statistics extends StatefulWidget {
  const Statistics(this.currentUser, {Key? key}) : super(key: key);
  static const String id = 'Statistics';
  final UserAccount currentUser;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  List<ValueOnCurrency> getValuesOnCurrency(
      {required String currency, required String type}) {
    List<ValueOnCurrency> currencyValues = [];
    Iterable<String> dates = currentUser.history.keys;
    if (type == 'error') {
      for (var d in dates) {
        currencyValues.add(ValueOnCurrency(
            d, currentUser.history[d]?.errorsOnCurrencies[currency]));
      }
    } else {
      for (var d in dates) {
        currencyValues.add(ValueOnCurrency(
            d, currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
      }
    }
    return currencyValues;
  }

  List<ValueOnCurrency> getValuesOnCurrencyNoNaN(
      {required String currency, required String type}) {
    List<ValueOnCurrency> currencyValues = [];
    Iterable<String> dates = currentUser.history.keys;
    if (type == 'error') {
      for (var d in dates) {
        if (!currentUser.history[d]?.errorsOnCurrencies[currency].isNaN) {
          currencyValues.add(ValueOnCurrency(
              d, currentUser.history[d]?.errorsOnCurrencies[currency]));
        }
      }
    } else {
      for (var d in dates) {
        if (!currentUser
            .history[d]?.errorVarianceOnCurrencies[currency].isNaN) {
          currencyValues.add(ValueOnCurrency(
              d, currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
        }
      }
    }
    return currencyValues;
  }

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
                RichText(text: TextSpan(

                ),),

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
