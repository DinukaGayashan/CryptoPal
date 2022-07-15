import 'package:cryptopal/utility/forecast_price_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'currency_forecast_graph.dart';

class CurrencyForecasts extends StatelessWidget {
  const CurrencyForecasts(this.realPriceList, this.forecastPriceList, this.currencyIndex, {Key? key}) : super(key: key);

  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> forecastPriceList;
  final int currencyIndex;

  List<RealPrice> getRealPrices({required String currency, int number = 0}) {
    List<RealPrice> realPrices = [];
    for (var type in realPriceList) {
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

  List<ForecastPrice> getForecastPrices({required String currency, int number = 0}) {
    List<ForecastPrice> forecastPrices = [];
    for (var type in forecastPriceList) {
      if (type.currency == currency) {
        forecastPrices = type.pricesList;
        break;
      }
    }
    if (number != 0 && forecastPrices.length > number) {
      return forecastPrices.sublist(0,forecastPrices.length - number);
    }
    return forecastPrices;
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
                  cryptocurrencyNames[currencyIndex] + ' Forecasts',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Forecast\n',
                        style: kCardSmallTextStyle,
                        children: <TextSpan>[
                      TextSpan(
                      text: 'Deviation\n',
                        style: kCardTextStyle,
                      ),
                          TextSpan(
                            text: '\$ '+forecastPriceList[currencyIndex].errorValue.roundToDouble().toString(),
                            style: kCardTextStyle2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: SfRadialGauge(
                        axes:[
                          RadialAxis(
                            startAngle: 90,
                            endAngle: 90,
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.15,
                              color: kBaseColor1,
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers:[
                              RangePointer(
                                color: kAccentColor1,
                                animationType: AnimationType.easeOutBack,
                                enableAnimation: true,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.15,
                                sizeUnit: GaugeSizeUnit.factor,
                                value: (100-forecastPriceList[currencyIndex].errorPercentage),
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Accuracy\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (100-forecastPriceList[currencyIndex].errorPercentage).roundToDouble().toString()
                                            .toString()+'%',
                                        style: kCardTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CurrencyForecastsGraph(realPriceList,forecastPriceList,currencyIndex);
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
                  child: charts.SfCartesianChart(
                    title: charts.ChartTitle(
                      text: 'Close Price',
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
                      zoomMode: charts.ZoomMode.xy,
                    ),
                    primaryXAxis: charts.DateTimeAxis(
                      visibleMinimum: kMinDayInForecastGraph,
                    ),
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
                      charts.LineSeries<RealPrice, DateTime>(
                        name: cryptocurrencies[currencyIndex] +
                            ' Real Price',
                        color: kGraphColor1,
                        dataSource: getRealPrices(
                            currency: cryptocurrencies[currencyIndex] +
                                '-USD'),
                        xValueMapper: (RealPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (RealPrice data, _) => data.closePrice,
                      ),
                      charts.LineSeries<ForecastPrice, DateTime>(
                        name: cryptocurrencies[currencyIndex] +
                            ' Forecast Price',
                        color: kGraphColor2,
                        dataSource: getForecastPrices(
                            currency: cryptocurrencies[currencyIndex]+
                      '-USD'),
                        xValueMapper: (ForecastPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (ForecastPrice data, _) => data.closePrice,
                      ),
                    ],
                  ),
                ),
                //TODO

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

