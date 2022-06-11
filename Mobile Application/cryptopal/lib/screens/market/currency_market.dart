import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import 'currency_market_graphs.dart';

class CurrencyMarket extends StatefulWidget {
  const CurrencyMarket(this.currencyIndex, this.realPriceList, {Key? key})
      : super(key: key);

  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<CurrencyMarket> createState() => _CurrencyMarketState();
}

class _CurrencyMarketState extends State<CurrencyMarket> {
  List<RealPrice> getRealPrices({required String currency, int number = 0}) {
    List<RealPrice> realPrices = [];
    for (var type in widget.realPriceList) {
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(context, cryptocurrencyNames[widget.currencyIndex]),
                const SizedBox(
                  height: 10.0,
                ),
                SvgPicture.asset(
                  'assets/images/cryptocoin_icons/color/' +
                      cryptocurrencies[widget.currencyIndex].toLowerCase() +
                      '.svg',
                  width: 60.0,
                  height: 60.0,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "\$ " +
                          widget.realPriceList[widget.currencyIndex].pricesList
                              .last.closePrice
                              .toStringAsFixed(6) +
                          ' ',
                      style: kCardNumberStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: cryptocurrencies[widget.currencyIndex],
                          style: kCardTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (double.parse((widget.realPriceList[widget.currencyIndex]
                                          .priceIncreasePercentage)
                                      .toStringAsFixed(2))
                                  .abs())
                              .toString() +
                          '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Bierstadt',
                        color: widget.realPriceList[widget.currencyIndex]
                                    .priceIncreasePercentage >
                                0
                            ? kGreen
                            : kRed,
                      ),
                    ),
                    Icon(
                      widget.realPriceList[widget.currencyIndex]
                                  .priceIncreasePercentage >
                              0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: widget.realPriceList[widget.currencyIndex]
                                  .priceIncreasePercentage >
                              0
                          ? kGreen
                          : kRed,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 380,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Close Price',
                      textStyle: kCardSmallTextStyle,
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
                        color: widget.realPriceList[widget.currencyIndex]
                                    .priceIncreasePercentage >
                                0
                            ? kGreen
                            : kRed,
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Close Price',
                        dataSource: getRealPrices(
                            currency: cryptocurrencies[widget.currencyIndex] +
                                '-USD'),
                        xValueMapper: (RealPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (RealPrice data, _) => data.closePrice,
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  child: const Text(
                    'More Graphs',
                    style: kLinkStyle,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 1,
                      color: kAccentColor3,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CurrencyMarketGraphs(
                          widget.realPriceList, widget.currencyIndex);
                    }));
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
