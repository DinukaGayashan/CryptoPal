import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';

class CurrencyOHLCGraph extends StatelessWidget {
  const CurrencyOHLCGraph(this.currencyIndex, this.realPriceList, {Key? key}) : super(key: key);

  static const String id = 'CurrencyOHLCGraph';
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: glassCard(context,
          Column(
            children: [
              topBar(context, cryptocurrencyNames[cryptocurrencies[currencyIndex]].toString()+' OHLC Prices'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-133,
                child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    enableMouseWheelZooming: true,
                    zoomMode: ZoomMode.xy,
                  ),
                  primaryXAxis: DateTimeAxis(
                    visibleMinimum: kMinDayInExtendedGraph,
                    dateFormat: DateFormat.yMd(),
                  ),
                  primaryYAxis: NumericAxis(),
                  plotAreaBorderWidth: 1,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  series: <ChartSeries>[
                    CandleSeries<RealPrice, DateTime>(
                      name: cryptocurrencies[currencyIndex] +
                          ' OHLC Prices',
                      dataSource: getRealPrices(
                          currency:
                          cryptocurrencies[currencyIndex] +
                              '-USD'),
                      xValueMapper: (RealPrice data, _) =>
                          DateTime.parse(data.date),
                      lowValueMapper: (RealPrice data, _) =>
                      data.lowestPrice,
                      highValueMapper: (RealPrice data, _) =>
                      data.highestPrice,
                      openValueMapper: (RealPrice data, _) =>
                      data.openPrice,
                      closeValueMapper: (RealPrice data, _) =>
                      data.closePrice,
                      enableSolidCandles: true,
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
