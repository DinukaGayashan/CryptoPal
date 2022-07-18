import 'package:cryptopal/screens/statistics/currency_prediction_statistics.dart';
import 'package:cryptopal/screens/statistics/prediction_accuracy_graph.dart';
import 'package:cryptopal/screens/statistics/prediction_error_graph.dart';
import 'package:cryptopal/screens/statistics/predictions_on_days.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/real_price_data.dart';

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

  List<GraphData> getValuesOnCurrency(
      {required String currency, required String type}) {
    List<GraphData> currencyValues = [];
    Iterable<String> dates = currentUser.history.keys;
    if (type == 'error') {
      for (var d in dates) {
        currencyValues.add(GraphData(
            valueOne:d, valueTwo:currentUser.history[d]?.errorsOnCurrencies[currency]));
      }
    } else {
      for (var d in dates) {
        currencyValues.add(GraphData(
            valueOne:d, valueTwo:currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
      }
    }
    return currencyValues;
  }

  List<GraphData> getValuesOnCurrencyNoNaN(
      {required String currency, required String type}) {
    List<GraphData> currencyValues = [];
    Iterable<String> dates = currentUser.history.keys;
    if (type == 'error') {
      for (var d in dates) {
        if (!currentUser.history[d]?.errorsOnCurrencies[currency].isNaN) {
          currencyValues.add(GraphData(
              valueOne:d, valueTwo:currentUser.history[d]?.errorsOnCurrencies[currency]));
        }
      }
    } else {
      for (var d in dates) {
        if (!currentUser
            .history[d]?.errorVarianceOnCurrencies[currency].isNaN) {
          currencyValues.add(GraphData(
              valueOne:d, valueTwo:currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
        }
      }
    }
    return currencyValues;
  }

  List<GraphData> getAccuracyHistoryNoNaN() {
    List<GraphData> accuracyValues = [];
    Iterable<String> dates = currentUser.history.keys;
    for (var d in dates) {
      if (currentUser.history[d]?.accuracy.isNaN!=true) {
        accuracyValues.add(GraphData(
            valueOne:d, valueTwo:currentUser.history[d]?.accuracy));
      }
    }
    return accuracyValues;
  }

  List<GraphData> getErrorHistoryNoNaN() {
    List<GraphData> errorValues = [];
    Iterable<String> dates = currentUser.history.keys;
    for (var d in dates) {
      if (currentUser.history[d]?.error.isNaN!=true) {
        errorValues.add(GraphData(
            valueOne:d, valueTwo:currentUser.history[d]?.error));
      }
    }
    return errorValues;
  }

  List<GraphData> getStandardDeviationHistoryNoNaN() {
    List<GraphData> standardDeviationValues = [];
    Iterable<String> dates = currentUser.history.keys;
    for (var d in dates) {
      if (currentUser.history[d]?.standardDeviation.isNaN!=true) {
        standardDeviationValues.add(GraphData(
            valueOne:d, valueTwo:currentUser.history[d]?.standardDeviation));
      }
    }
    return standardDeviationValues;
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
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Statistics'),
                const SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(currentUser.history.length.toString(),style: kCardTextStyle3,),
                          const SizedBox(width: 5,),
                          RichText(
                            text: const TextSpan(
                              text: 'Total\n',
                              style: kCardSmallTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Active Days',
                                  style: kCardTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(currentUser.predictions.length.toString(),style: kCardTextStyle3,),
                          const SizedBox(width: 5,),
                          RichText(
                            text: const TextSpan(
                              text: 'Total\n',
                              style: kCardSmallTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Predictions',
                                  style: kCardTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  height: 50.0,
                ),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
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
                            thickness: 15.0,
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
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
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
                            thickness: 15.0,
                            enableAnimation: true,
                            value: currentUser.errorStandardDeviation,
                            color: kRed,
                            edgeStyle: LinearEdgeStyle.startCurve,
                            position: LinearElementPosition.outside,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width:60,child: Text('${currentUser.errorStandardDeviation.roundToDouble()}%',style: kCardTextStyle,textAlign: TextAlign.right,)),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
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
                      height: 65,
                      child: charts.SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryYAxis: charts.NumericAxis(
                          maximum: 50,
                          minimum: -50,
                        ),
                          primaryXAxis: charts.CategoryAxis(
                            isVisible: false,
                          ),
                        series: <charts.ChartSeries>[
                          charts.BarSeries<GraphData, String>(
                            color:kRed,
                            borderRadius: BorderRadius.circular(20),
                            dataSource: errorForGraph,
                            xValueMapper: (GraphData data, _) => data.valueOne,
                            yValueMapper: (GraphData data, _) => data.valueTwo,
                          ),
                        ],
                    ),
                    ),
                    SizedBox(width:60,child: Text('${currentUser.error.roundToDouble()}%',style: kCardTextStyle,textAlign: TextAlign.right,)),
                  ],
                ),
                const SizedBox(height: 40,),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PredictionAccuracyGraph(
                                  currentUser);
                            }));
                      },
                      icon: const Icon(
                        Icons.fullscreen,
                      ),
                      tooltip: 'Full Screen View',
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                ),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                SizedBox(
                  width: double.infinity,
                  child: charts.SfCartesianChart(
                    title: charts.ChartTitle(
                      text: 'Price Prediction Accuracy',
                      textStyle: kCardSmallTextStyle,
                    ),
                    legend: charts.Legend(
                      isVisible: true,
                      overflowMode: charts.LegendItemOverflowMode.wrap,
                      position: charts.LegendPosition.bottom,
                    ),
                    zoomPanBehavior: charts.ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableMouseWheelZooming: true,
                      zoomMode: charts.ZoomMode.x,
                    ),
                    primaryXAxis: charts.DateTimeAxis(),
                    primaryYAxis: charts.NumericAxis(),
                    plotAreaBorderWidth: 1,
                    enableAxisAnimation: true,
                    crosshairBehavior: charts.CrosshairBehavior(
                      enable: true,
                    ),
                    tooltipBehavior: charts.TooltipBehavior(
                      enable: true,
                    ),
                    series: <charts.ChartSeries>[
                      charts.ScatterSeries<GraphData, DateTime>(
                        name: 'Price Prediction Accuracy',
                        color: kGraphColor1,
                        dataSource: getAccuracyHistoryNoNaN(),
                        trendlines:<charts.Trendline>[
                          charts.Trendline(
                            name: 'Trendline',
                            color: kGraphColor1,
                            type: charts.TrendlineType.polynomial,
                          )
                        ],
                        xValueMapper: (GraphData data, _) =>
                            DateTime.parse(data.valueOne),
                        yValueMapper: (GraphData data, _) =>
                        data.valueTwo,
                        markerSettings: const charts.MarkerSettings(
                          isVisible: true,
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PredictionErrorGraph(
                                  currentUser);
                            }));
                      },
                      icon: const Icon(
                        Icons.fullscreen,
                      ),
                      tooltip: 'Full Screen View',
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                ),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                SizedBox(
                  width: double.infinity,
                  child: charts.SfCartesianChart(
                    title: charts.ChartTitle(
                      text: 'Price Prediction Error',
                      textStyle: kCardSmallTextStyle,
                    ),
                    legend: charts.Legend(
                      isVisible: true,
                      overflowMode: charts.LegendItemOverflowMode.wrap,
                      position: charts.LegendPosition.bottom,
                    ),
                    zoomPanBehavior: charts.ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableMouseWheelZooming: true,
                      zoomMode: charts.ZoomMode.x,
                    ),
                    primaryXAxis: charts.DateTimeAxis(),
                    primaryYAxis: charts.NumericAxis(),
                    plotAreaBorderWidth: 1,
                    enableAxisAnimation: true,
                    crosshairBehavior: charts.CrosshairBehavior(
                      enable: true,
                    ),
                    tooltipBehavior: charts.TooltipBehavior(
                      enable: true,
                    ),
                    series: <charts.ChartSeries>[
                      charts.ScatterSeries<GraphData, DateTime>(
                        name: 'Price Prediction Error Deviation',
                        color: kGraphColor2,
                        dataSource: getStandardDeviationHistoryNoNaN(),
                        trendlines:<charts.Trendline>[
                          charts.Trendline(
                            name: 'Trendline',
                            color: kGraphColor2,
                            type: charts.TrendlineType.polynomial,
                          )
                        ],
                        xValueMapper: (GraphData data, _) =>
                            DateTime.parse(data.valueOne),
                        yValueMapper: (GraphData data, _) =>
                        data.valueTwo,
                        markerSettings: const charts.MarkerSettings(
                          isVisible: true,
                          height: 2,
                          width: 2,
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 50,),
                currentUser.pastPredictions.isEmpty?
                const SizedBox():
                const Center(
                  child: Text(
                    'Price Prediction Accuracy of Cryptocurrencies',
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
                const SizedBox(height: 10.0,),
                for (int i = 0; i < currenciesWithPastPredictions.length; i++)
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    child: glassCard(
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
                                      cryptocurrencies[i].toLowerCase() +
                                      '.svg',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  cryptocurrencies[i],
                                  style: kCardTextStyle,
                                ),
                                Text(
                                  cryptocurrencyNames[cryptocurrencies[i]].toString(),
                                  style: kCardSmallTextStyle,
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
                currentUser.pastPredictions.isEmpty?
                const Text('Statistics will be displayed when a prediction is completed.',style: kInstructionStyle,textAlign: TextAlign.center,):
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
