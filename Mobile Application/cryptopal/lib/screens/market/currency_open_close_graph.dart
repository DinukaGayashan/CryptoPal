import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';

class CurrencyOpenCloseGraph extends StatelessWidget {
  const CurrencyOpenCloseGraph(this.currencyIndex, this.realPriceList, this.showClose,this.showOpen, {Key? key}) : super(key: key);

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
    return SafeArea(
      child: glassCardFullScreen(context,
        Column(
          children: [
            topBar(context, cryptocurrencyNames[currencyIndex]+' Open Close Prices'),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-135,
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
                    name: cryptocurrencies[currencyIndex] +
                        ' Close Price',
                    dataSource: getRealPrices(
                        currency:
                        cryptocurrencies[currencyIndex] +
                            '-USD'),
                    xValueMapper: (RealPrice data, _) =>
                        DateTime.parse(data.date),
                    yValueMapper: (RealPrice data, _) =>
                    data.closePrice,
                    //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                  ),
                  LineSeries<RealPrice, DateTime>(
                    isVisible: showOpen,
                    name: cryptocurrencies[currencyIndex] +
                        ' Open Price',
                    dataSource: getRealPrices(
                        currency:
                        cryptocurrencies[currencyIndex] +
                            '-USD'),
                    xValueMapper: (RealPrice data, _) =>
                        DateTime.parse(data.date),
                    yValueMapper: (RealPrice data, _) =>
                    data.openPrice,
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
