import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import '../../utility/real_price_data.dart';

class CurrencyPredictionErrorsGraph extends StatelessWidget {
  const CurrencyPredictionErrorsGraph(this.currentUser, this.currencyIndex, {Key? key}) : super(key: key);

  final UserAccount currentUser;
  final int currencyIndex;

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
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: glassCard(context,
          Column(
            children: [
              topBar(context, cryptocurrencyNames[currencyIndex]+' Prediction Error'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-133,
                child: SfCartesianChart(
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
                      name: cryptocurrencies[currencyIndex] +
                          ' Prediction Error Deviation',
                      color: kGraphColor2,
                      dataSource: getValuesOnCurrencyNoNaN(
                          currency: cryptocurrencies[
                          currencyIndex],
                          type: 'variance'),
                      trendlines:<Trendline>[
                        Trendline(
                          name: 'Trendline',
                          color: kGraphColor2,
                          type: TrendlineType.polynomial,
                        )
                      ],
                      xValueMapper: (GraphData data, _) => DateTime.parse(data.valueOne),
                      yValueMapper: (GraphData data, _) => sqrt(data.valueTwo).toDouble(),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 2,
                        width: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
