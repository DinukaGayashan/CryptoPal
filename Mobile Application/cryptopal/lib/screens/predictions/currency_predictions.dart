import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'currency_future_predictions.dart';
import 'currency_past_predictions.dart';
import 'currency_predictions_graph.dart';

class CurrencyPredictions extends StatefulWidget {
  const CurrencyPredictions(
      this.currentUser, this.currencyIndex, this.realPriceList,
      {Key? key})
      : super(key: key);

  static const String id = 'CurrencyPredictions';
  final UserAccount currentUser;
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<CurrencyPredictions> createState() => _CurrencyPredictionsState();
}

class _CurrencyPredictionsState extends State<CurrencyPredictions> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(
                  context,
                  cryptocurrencyNames[selectedCryptocurrencies[widget.currencyIndex]].toString()+ ' Predictions',
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
                              ((currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!)
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
                getUserPredictions(
                            currency: selectedCryptocurrencies[widget.currencyIndex],
                            past: true)
                        .isEmpty
                    ? const SizedBox()
                    : SfLinearGauge(
                        minimum: 0,
                        maximum: 100,
                        showTicks: false,
                        showAxisTrack: false,
                        isMirrored: true,
                        barPointers: [
                          LinearBarPointer(
                            thickness: 25.0,
                            enableAnimation: true,
                            //animationDuration: kAnimationTime,
                            value: (currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!).roundToDouble(),
                            color: ((currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[selectedCryptocurrencies[widget.currencyIndex]]!)
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
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kTransparentColor1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Past Predictions\n',
                                style: kCardSmallTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getUserPredictions(
                                            currency: selectedCryptocurrencies[
                                                widget.currencyIndex],
                                            past: true)
                                        .length
                                        .toString(),
                                    style: kCardTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CurrencyPastPredictions(currentUser,
                              widget.currencyIndex, widget.realPriceList);
                        }));
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kTransparentColor1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Future Predictions\n',
                                style: kCardSmallTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: (getUserPredictions(
                                                    currency: selectedCryptocurrencies[
                                                        widget.currencyIndex])
                                                .length -
                                            getUserPredictions(
                                                    currency: selectedCryptocurrencies[
                                                        widget.currencyIndex],
                                                    past: true)
                                                .length)
                                        .toString(),
                                    style: kCardTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CurrencyFuturePredictions(currentUser,
                              widget.currencyIndex, widget.realPriceList);
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
                      text: 'Close Price',
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
                      zoomMode: ZoomMode.x,
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
                        name: selectedCryptocurrencies[widget.currencyIndex] +
                            ' Close Price',
                        color: kGraphColor1,
                        dataSource: getRealPrices(
                            currency: selectedCryptocurrencies[widget.currencyIndex] +
                                '-USD'),
                        xValueMapper: (RealPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (RealPrice data, _) => data.closePrice,
                      ),
                      LineSeries<Prediction, DateTime>(
                        name: selectedCryptocurrencies[widget.currencyIndex] +
                            ' Prediction',
                        color: kGraphColor2,
                        dataSource: getUserPredictions(
                            currency: selectedCryptocurrencies[widget.currencyIndex]),
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
