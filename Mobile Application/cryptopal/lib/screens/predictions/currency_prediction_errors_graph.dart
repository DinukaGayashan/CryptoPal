import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class CurrencyPredictionErrorsGraph extends StatelessWidget {
  const CurrencyPredictionErrorsGraph(this.currentUser, this.currencyIndex, {Key? key}) : super(key: key);

  static const String id = 'CurrencyPredictionErrorsGraph';
  final UserAccount currentUser;
  final int currencyIndex;

  List<ValueOnCurrency> getValuesOnCurrency({required String currency, required String type}){
    List<ValueOnCurrency> currencyValues=[];
    Iterable<String> dates=currentUser.history.keys;
    if(type=='error'){
      for(var d in dates){
        currencyValues.add(ValueOnCurrency(d,currentUser.history[d]?.errorsOnCurrencies[currency]));
      }
    }
    else {
      for(var d in dates){
        currencyValues.add(ValueOnCurrency(d,currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
      }
    }
    return currencyValues;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: glassCard(context,
        Column(
          children: [
            topBar(context, cryptocurrencyNames[currencyIndex]+' Prediction Errors'),
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
                  LineSeries<ValueOnCurrency, DateTime>(
                    name: cryptocurrencies[currencyIndex]+' Prediction Error',
                    dataSource: getValuesOnCurrency(currency: cryptocurrencies[currencyIndex], type: 'error'),
                    xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                    yValueMapper: (ValueOnCurrency data, _) => data.value.toDouble(),
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
                  ),
                  LineSeries<ValueOnCurrency, DateTime>(
                    name: cryptocurrencies[currencyIndex]+' Prediction Error Deviation',
                    dataSource: getValuesOnCurrency(currency: cryptocurrencies[currencyIndex], type: 'variance'),
                    xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                    yValueMapper: (ValueOnCurrency data, _) => sqrt(data.value).toDouble(),
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
