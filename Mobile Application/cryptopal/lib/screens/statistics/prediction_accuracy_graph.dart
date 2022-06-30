import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import '../../utility/database_data.dart';

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
    return SafeArea(
      child: glassCardFullScreen(context,
        Column(
          children: [
            topBar(context,'Price Prediction Accuracy'),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-135,
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
                  SplineSeries<GraphData, DateTime>(
                    name: 'Price Prediction Accuracy',
                    dataSource: getAccuracyHistoryNoNaN(),
                    xValueMapper: (GraphData data, _) =>
                        DateTime.parse(data.valueOne),
                    yValueMapper: (GraphData data, _) =>
                    data.valueTwo,
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
    );
  }
}
