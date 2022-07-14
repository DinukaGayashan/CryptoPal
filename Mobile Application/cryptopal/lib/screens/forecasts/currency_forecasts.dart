import 'package:cryptopal/utility/forecast_price_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
      return forecastPrices.sublist(forecastPrices.length - number);
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
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Forecast Accuracy',
                      style: kCardSmallTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ' +
                              (100-forecastPriceList[currencyIndex].errorPercentage).roundToDouble().toString()+
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
                      //animationDuration: kAnimationTime,
                      value: (100-forecastPriceList[currencyIndex].errorPercentage),
                      color: ((100-forecastPriceList[currencyIndex].errorPercentage)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {

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
                      LineSeries<ForecastPrice, DateTime>(
                        name: cryptocurrencies[currencyIndex] +
                            ' Forecast Price',
                        color: kGraphColor2,
                        dataSource: getForecastPrices(
                            currency: cryptocurrencies[currencyIndex]),
                        xValueMapper: (ForecastPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (ForecastPrice data, _) =>
                        data.closePrice,
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

