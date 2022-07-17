import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import '../../utility/real_price_data.dart';

class PredictionAccuracyGraph extends StatelessWidget {
  const PredictionAccuracyGraph(this.currentUser, {Key? key}) : super(key: key);

  final UserAccount currentUser;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: glassCard(context,
          Column(
            children: [
              topBar(context,'Price Prediction Accuracy'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-160,
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
                      name: 'Price Prediction Accuracy',
                      color:kGraphColor1,
                      dataSource: getAccuracyHistoryNoNaN(),
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
                      data.valueTwo,
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
