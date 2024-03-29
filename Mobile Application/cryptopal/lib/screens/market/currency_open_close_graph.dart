import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';

class CurrencyOpenCloseGraph extends StatelessWidget {
  const CurrencyOpenCloseGraph(
      this.currencyIndex, this.realPriceList, this.showClose, this.showOpen,
      {Key? key})
      : super(key: key);

  static const String id = 'CurrencyOpenCloseGraph';
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;
  final bool showClose;
  final bool showOpen;

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
        child: glassCard(
          context,
          Column(
            children: [
              topBar(context,
                  '${cryptocurrencyNames[selectedCryptocurrencies[currencyIndex]]} Open Close Prices'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 155,
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
                  crosshairBehavior: CrosshairBehavior(
                    enable: true,
                  ),
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                  ),
                  series: <ChartSeries>[
                    LineSeries<RealPrice, DateTime>(
                      isVisible: showClose,
                      name:
                          '${selectedCryptocurrencies[currencyIndex]} Close Price',
                      color: kGraphColor1,
                      dataSource: getRealPrices(
                          currency:
                              '${selectedCryptocurrencies[currencyIndex]}-USD'),
                      xValueMapper: (RealPrice data, _) =>
                          DateTime.parse(data.date),
                      yValueMapper: (RealPrice data, _) => data.closePrice,
                      //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                    ),
                    LineSeries<RealPrice, DateTime>(
                      isVisible: showOpen,
                      name:
                          '${selectedCryptocurrencies[currencyIndex]} Open Price',
                      color: kGraphColor2,
                      dataSource: getRealPrices(
                          currency:
                              '${selectedCryptocurrencies[currencyIndex]}-USD'),
                      xValueMapper: (RealPrice data, _) =>
                          DateTime.parse(data.date),
                      yValueMapper: (RealPrice data, _) => data.openPrice,
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
