import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import '../../utility/database_data.dart';

class PredictionErrorGraph extends StatelessWidget {
  const PredictionErrorGraph(this.currentUser, {Key? key}) : super(key: key);

  final UserAccount currentUser;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: glassCardFullScreen(context,
        Column(
          children: [
            topBar(context,'Price Prediction Errors'),
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
                    name: 'Price Prediction Error',
                    dataSource: getErrorHistoryNoNaN(),
                    xValueMapper: (GraphData data, _) =>
                        DateTime.parse(data.valueOne),
                    yValueMapper: (GraphData data, _) =>
                    data.valueTwo,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
                  ),
                  SplineSeries<GraphData, DateTime>(
                    name: 'Price Prediction Error Deviation',
                    dataSource: getStandardDeviationHistoryNoNaN(),
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
