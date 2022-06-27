import 'package:cryptopal/screens/statistics/predictions_on_days.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:cryptopal/utility/database_data.dart';

class Statistics extends StatefulWidget {
  const Statistics(this.currentUser, this.realPriceList ,{Key? key}) : super(key: key);
  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late List<String> currenciesWithPastPredictions=[];
  late List<String> currenciesWithPredictions=[];
  late Map<String,List<Prediction>> predictionsOnDays={};

  void getStatisticData(){
    currenciesWithPastPredictions.clear();
    currenciesWithPredictions.clear();
    for(var c in cryptocurrencies){
      if(getUserPredictions(currency: c, past:true).isNotEmpty){
        currenciesWithPastPredictions.add(c);
      }
      if(getUserPredictions(currency: c, past:false).isNotEmpty){
        currenciesWithPredictions.add(c);
      }
    }

    for(int d=0;d<currentUser.history.keys.length;d++){
      List<Prediction> predictions=[];
      for(var p in currentUser.predictions){
        if(currentUser.history.keys.elementAt(d)==p.predictedDate){
          predictions.add(p);
        }
      }
      predictionsOnDays[currentUser.history.keys.elementAt(d)]=predictions;
    }
  }

  int getCryptocurrencyIndex(String predictionCurrency){
    int i=0;
    for(i=0;i<cryptocurrencies.length;i++){
      if(cryptocurrencies[i]==predictionCurrency.split('-')[0]){
        break;
      }
    }
    return i;
  }

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

  List<Prediction> getUserPredictions(
      {required String currency, bool past = false}) {
    List<Prediction> predictions = [];
    List<Prediction> predictionSnap =
    past ? currentUser.pastPredictions : currentUser.predictions;
    if (currency == 'all') {
      predictions = predictionSnap;
    } else {
      for (var prediction in predictionSnap) {
        if (prediction.predictionCurrency == currency + '-USD') {
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  @override
  Widget build(BuildContext context) {
    getStatisticData();

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
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currentUser.history.length.toString(),style: kCardTextStyle3,),
                      const SizedBox(width: 5,),
                      const Text('Total\nActive\nDays',style: kCardSmallTextStyle,),
                      const SizedBox(width: 50,),
                      const Text('Total\nPredictions',style: kCardSmallTextStyle,textAlign: TextAlign.right,),
                      const SizedBox(width: 5,),
                      Text(currentUser.predictions.length.toString(),style: kCardTextStyle3,),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return PredictionsOnDays(predictionsOnDays,widget.realPriceList);
                        }));
                  },
                ),

                const SizedBox(
                  height: 30.0,
                ),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                const Center(
                  child: Text(
                    'Cryptocurrency Prediction Accuracy',
                    style: kCardSmallTextStyle,
                  ),
                ),
                const SizedBox(height: 15.0,),
                currentUser.pastPredictions.isEmpty?
                    const SizedBox():
                SfLinearGauge(
                  minimum: 0,
                  maximum: 100,
                  //showLabels: false,
                  //showTicks: false,
                  showAxisTrack: false,
                  isMirrored: true,
                  barPointers: [
                    for(int i=0;i<currenciesWithPastPredictions.length;i++)
                      LinearBarPointer(
                        thickness: 25.0,
                        enableAnimation: true,
                        value: ((currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!)
                            .roundToDouble()),
                        color: ((currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!)
                            .roundToDouble())>50?kGreen:kRed,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        offset: i*30+35,
                        position: LinearElementPosition.outside,
                        child: Center(
                          child: Text(
                            currenciesWithPastPredictions[i]+' '+((currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!)
                                .roundToDouble()).toString()+'%',
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
