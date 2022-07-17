import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';

import '../../utility/forecast_price_data.dart';

class CurrencyForecastsGraph extends StatelessWidget {
  const CurrencyForecastsGraph(this.realPriceList, this.forecastPriceList, this.currencyIndex, {Key? key}) : super(key: key);

  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> forecastPriceList;
  final int currencyIndex;

  List<RealPrice> getRealPrices ({required String currency, int number=0}){
    List<RealPrice> realPrices=[];
    for(var type in realPriceList){
      if(type.currency==currency){
        realPrices=type.pricesList;
        break;
      }
    }
    if(number!=0 && realPrices.length>number){
      return realPrices.sublist(realPrices.length-number);
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
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: glassCard(context,
          Column(
            children: [
              topBar(context, cryptocurrencyNames[currencyIndex]+' Forecasts'),
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
                  primaryXAxis: DateTimeAxis(
                    visibleMinimum: kMinDayInForecastGraph,
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
                          currency: cryptocurrencies[currencyIndex]+
                              '-USD'),
                      xValueMapper: (ForecastPrice data, _) =>
                          DateTime.parse(data.date),
                      yValueMapper: (ForecastPrice data, _) => data.closePrice,
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
