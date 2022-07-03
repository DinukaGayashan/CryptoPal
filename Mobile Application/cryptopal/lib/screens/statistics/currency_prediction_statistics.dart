import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../predictions/currency_predictions_graph.dart';
import 'currency_prediction_accuracy_graph.dart';
import 'currency_prediction_errors_graph.dart';

class CurrencyPredictionStatistics extends StatefulWidget {
  const CurrencyPredictionStatistics(
      this.currentUser, this.currencyIndex, this.realPriceList,
      {Key? key})
      : super(key: key);

  final UserAccount currentUser;
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<CurrencyPredictionStatistics> createState() => _CurrencyPredictionStatisticsState();
}

class _CurrencyPredictionStatisticsState extends State<CurrencyPredictionStatistics> {
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

  List<Prediction> getUserFuturePredictions({required String currency}) {
    List<Prediction> predictions = [];
    for (var p in currentUser.futurePredictions) {
      if (p.predictionCurrency == currency + '-USD') {
        predictions.add(p);
      }
    }
    return predictions;
  }

  List<RealPrice> getRealPrices({required String currency, int number = 0}) {
    List<RealPrice> realPrices = [];
    for (var type in widget.realPriceList) {
      if (type.currency == currency) {
        realPrices = type.pricesList;
        break;
      }
    }
    if (number != 0 && realPrices.length > number) {
      return realPrices.sublist(realPrices.length - number);
    }
    return realPrices;
  }

  RealPrice? getRealPrice({required String currency, required String date}) {
    final List<RealPrice> priceList =
    getRealPrices(currency: currency + '-USD');
    RealPrice x = RealPrice(date, 0, 0, 0, 0);
    for (var i in priceList) {
      if (i.date == date) {
        x = i;
      }
    }
    return x;
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
                topBar(
                  context,
                  cryptocurrencyNames[widget.currencyIndex] + ' Predictions',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Prediction Accuracy',
                      style: kCardSmallTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ' +
                              ((currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!)
                                  .roundToDouble())
                                  .toString() +
                              '%',
                          style: kCardTextStyle2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SfLinearGauge(
                  minimum: 0,
                  maximum: 100,
                  showTicks: false,
                  showAxisTrack: false,
                  isMirrored: true,
                  barPointers: [
                    LinearBarPointer(
                      thickness: 25.0,
                      enableAnimation: true,
                      value: (currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!).roundToDouble(),
                      color: ((currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[widget.currencyIndex]]!)
                          .roundToDouble()) >
                          50
                          ? kGreen
                          : kRed,
                      edgeStyle: LinearEdgeStyle.bothCurve,
                      offset: 20,
                      position: LinearElementPosition.outside,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CurrencyPredictionsGraph(currentUser,
                                  widget.currencyIndex, widget.realPriceList);
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
                SizedBox(
                  width: double.infinity,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Close Price Predictions',
                      textStyle: kCardSmallTextStyle,
                    ),
                    legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                      position: LegendPosition.bottom,
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableMouseWheelZooming: true,
                      zoomMode: ZoomMode.xy,
                    ),
                    primaryXAxis: DateTimeAxis(
                      visibleMinimum: kMinDayInGraph,
                    ),
                    primaryYAxis: NumericAxis(),
                    plotAreaBorderWidth: 1,
                    enableAxisAnimation: true,
                    crosshairBehavior: CrosshairBehavior(
                      enable: true,
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                    series: <ChartSeries>[
                      LineSeries<RealPrice, DateTime>(
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Close Price',
                        color: kGraphColor1,
                        dataSource: getRealPrices(
                            currency: cryptocurrencies[widget.currencyIndex] +
                                '-USD'),
                        xValueMapper: (RealPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (RealPrice data, _) => data.closePrice,
                      ),
                      LineSeries<Prediction, DateTime>(
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Prediction',
                        color: kGraphColor2,
                        dataSource: getUserPredictions(
                            currency: cryptocurrencies[widget.currencyIndex]),
                        xValueMapper: (Prediction data, _) =>
                        data.predictionDateAsDate,
                        yValueMapper: (Prediction data, _) =>
                        data.predictionClosePrice,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return CurrencyPredictionAccuracyGraph(
                                      currentUser, widget.currencyIndex);
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
                    SizedBox(
                      width: double.infinity,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: 'Prediction Accuracy',
                          textStyle: kCardSmallTextStyle,
                        ),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          position: LegendPosition.bottom,
                        ),
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePinching: true,
                          enablePanning: true,
                          enableMouseWheelZooming: true,
                          zoomMode: ZoomMode.xy,
                        ),
                        primaryXAxis: DateTimeAxis(),
                        primaryYAxis: NumericAxis(),
                        plotAreaBorderWidth: 1,
                        enableAxisAnimation: true,
                        crosshairBehavior: CrosshairBehavior(
                          enable: true,
                        ),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                        ),
                        series: <ChartSeries>[
                          ScatterSeries<GraphData, DateTime>(
                            name: '${cryptocurrencies[widget.currencyIndex]} Prediction Accuracy',
                            color: kGraphColor1,
                            dataSource: getValuesOnCurrencyNoNaN(
                                currency: cryptocurrencies[
                                widget.currencyIndex],
                            type: 'variance'),
                            trendlines:<Trendline>[
                              Trendline(
                                name: 'Trendline',
                                color: kGraphColor1,
                                type: TrendlineType.polynomial,
                              )
                            ],
                            xValueMapper: (GraphData data, _) =>
                                DateTime.parse(data.valueOne),
                            yValueMapper: (GraphData data, _) =>
                                data.valueTwo>1000?0:100-sqrt(data.valueTwo),
                            markerSettings: const MarkerSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CurrencyPredictionErrorsGraph(
                                  currentUser, widget.currencyIndex);
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
                SizedBox(
                  width: double.infinity,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Past Prediction Errors',
                      textStyle: kCardSmallTextStyle,
                    ),
                    legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                      position: LegendPosition.bottom,
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableMouseWheelZooming: true,
                      zoomMode: ZoomMode.xy,
                    ),
                    primaryXAxis: DateTimeAxis(),
                    primaryYAxis: NumericAxis(),
                    plotAreaBorderWidth: 1,
                    enableAxisAnimation: true,
                    crosshairBehavior: CrosshairBehavior(
                      enable: true,
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                    series: <ChartSeries>[
                      ScatterSeries<GraphData, DateTime>(
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Prediction Error',
                        color: kGraphColor1,
                        dataSource: getValuesOnCurrencyNoNaN(
                            currency: cryptocurrencies[
                            widget.currencyIndex],
                            type: 'error'),
                        trendlines:<Trendline>[
                          Trendline(
                            name: 'Trendline',
                            color: kGraphColor1,
                            type: TrendlineType.polynomial,
                          )
                        ],
                        xValueMapper: (GraphData data, _) =>
                            DateTime.parse(data.valueOne),
                        yValueMapper: (GraphData data, _) =>
                            data.valueTwo.toDouble(),
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                        ),
                      ),
                      ScatterSeries<GraphData, DateTime>(
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Prediction Error Deviation',
                        color: kGraphColor2,
                        dataSource: getValuesOnCurrencyNoNaN(
                            currency: cryptocurrencies[
                            widget.currencyIndex],
                            type: 'variance'),
                        trendlines:<Trendline>[
                          Trendline(
                            name: 'Trendline',
                            color: kGraphColor2,
                            type: TrendlineType.polynomial,
                          )
                        ],
                        xValueMapper: (GraphData data, _) =>
                            DateTime.parse(data.valueOne),
                        yValueMapper: (GraphData data, _) =>
                            sqrt(data.valueTwo.toDouble()),
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
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



