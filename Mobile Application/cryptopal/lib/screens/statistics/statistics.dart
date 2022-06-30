import 'package:cryptopal/screens/statistics/currency_prediction_statistics.dart';
import 'package:cryptopal/screens/statistics/predictions_on_days.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
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
  late List<GraphData> errorForGraph=[];

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

    errorForGraph.clear();
    errorForGraph.add(GraphData(valueOne:'error', valueTwo:currentUser.error.toDouble()));
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
          child: glassCardFullScreen(
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
                      const Text('Total\nActive Days',style: kCardSmallTextStyle,),
                      const SizedBox(width: 50,),
                      Text(currentUser.predictions.length.toString(),style: kCardTextStyle3,),
                      const SizedBox(width: 5,),
                      const Text('Total\nPredictions',style: kCardSmallTextStyle,),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return PredictionsOnDays(predictionsOnDays,widget.realPriceList);
                        }));
                  },
                ),
                /*const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentUser.accuracy.round().toString()+'%',style: kCardTextStyle3,),
                    const SizedBox(width: 5,),
                    const Text('Average\nAccuracy',style: kCardSmallTextStyle,),
                    const SizedBox(width: 40,),
                    Text(currentUser.error.round().toString()+'%',style: kCardTextStyle3,),
                    const SizedBox(width: 5,),
                    const Text('Average\nError',style: kCardSmallTextStyle,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentUser.errorStandardDeviation.round().toString()+'%',style: kCardTextStyle2,),
                    const SizedBox(width: 5,),
                    const Text('Error Deviation',style: kCardSmallTextStyle,),
                    const SizedBox(width: 50,),
                    Text(currentUser.errorVariance.round().toString()+'%',style: kCardTextStyle2,),
                    const SizedBox(width: 5,),
                    const Text('Error Variance',style: kCardSmallTextStyle,),
                  ],
                ),*/
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 90,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Average\n',
                          style: kCardSmallTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Accuracy',
                              style: kCardTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-210,
                      child: SfLinearGauge(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        showAxisTrack: false,
                        barPointers: [
                          LinearBarPointer(
                            thickness: 25.0,
                            enableAnimation: true,
                            value: currentUser.accuracy,
                            color: kGreen,
                            edgeStyle: LinearEdgeStyle.startCurve,
                            position: LinearElementPosition.outside,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 60,child: Text(currentUser.accuracy.roundToDouble().toString()+'%',style: kCardTextStyle,textAlign: TextAlign.right,)),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 90,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Average Error\n',
                          style: kCardSmallTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Deviation',
                              style: kCardTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-210,
                      child: SfLinearGauge(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        showAxisTrack: false,
                        isAxisInversed: true,
                        barPointers: [
                          LinearBarPointer(
                            thickness: 25.0,
                            enableAnimation: true,
                            value: currentUser.errorStandardDeviation,
                            color: kRed,
                            edgeStyle: LinearEdgeStyle.startCurve,
                            position: LinearElementPosition.outside,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:60,child: Text(currentUser.errorStandardDeviation.roundToDouble().toString()+'%',style: kCardTextStyle,textAlign: TextAlign.right,)),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 90,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Average\n',
                          style: kCardSmallTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Error',
                              style: kCardTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-210,
                      height: 80,
                      child: charts.SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryYAxis: charts.NumericAxis(
                          maximum: 50,
                          minimum: -50,
                          //isVisible: false,
                        ),
                          primaryXAxis: charts.CategoryAxis(
                            isVisible: false,
                          ),
                        series: <charts.ChartSeries>[
                          charts.BarSeries<GraphData, String>(
                            name: 'Number of predictions',
                            color:kRed,
                            borderRadius: BorderRadius.circular(20),
                            dataSource: errorForGraph,
                            xValueMapper: (GraphData data, _) => data.valueOne,
                            yValueMapper: (GraphData data, _) => data.valueTwo,
                          ),
                        ],
                    ),
                    ),
                    SizedBox(width:60,child: Text(currentUser.error.roundToDouble().toString()+'%',style: kCardTextStyle,textAlign: TextAlign.right,)),
                  ],
                ),



                const SizedBox(height: 40,),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                const Center(
                  child: Text(
                    'Cryptocurrency Price Prediction Accuracy',
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
                for (int i = 0; i < currenciesWithPastPredictions.length; i++)
                  GestureDetector(
                    child: glassCardFullScreen(
                      context,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/cryptocoin_icons/color/' +
                                      currenciesWithPastPredictions[i].toLowerCase() +
                                      '.svg',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currenciesWithPastPredictions[i],
                                  style: kCardTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Predictions\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: getUserPredictions(
                                            currency: currenciesWithPastPredictions[i])
                                            .length
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Accuracy\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ((currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[currenciesWithPastPredictions[i]]!)
                                            .roundToDouble())
                                            .toString()+'%',
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Past Predictions\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: getUserPredictions(
                                            currency: currenciesWithPastPredictions[i],
                                            past: true)
                                            .length
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Average Error\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (currentUser
                                            .errorsOnCurrencies[
                                        currenciesWithPastPredictions[i]] ??
                                            0)
                                            .roundToDouble()
                                            .toString()+'%',
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CurrencyPredictionStatistics(
                              currentUser,
                              getCryptocurrencyIndex(currenciesWithPastPredictions[i]),
                              widget.realPriceList,
                            );
                          })).then((_) {
                        setState(() {
                          currentUser.predictions;
                          currentUser.futurePredictions;
                        });
                      });
                    },
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
