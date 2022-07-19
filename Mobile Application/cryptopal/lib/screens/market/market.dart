import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utility/constants.dart';
import '../../utility/cryptocurrency_data.dart';
import '../../utility/real_price_data.dart';
import '../../utility/widgets.dart';
import 'currency_market.dart';

class Market extends StatelessWidget {
  const Market(this.realPriceList, {Key? key}) : super(key: key);

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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            CupertinoScrollbar(
              child: ListView(
                children: <Widget>[
                  topBar(context, 'Market'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  for (int i = 0; (i < selectedCryptocurrencies.length); i++)
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      child: glassCard(context,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/cryptocoin_icons/color/' +
                                        selectedCryptocurrencies[i].toLowerCase() +
                                        '.svg',
                                    width: 45.0,
                                    height: 45.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        selectedCryptocurrencies[i],
                                        style: kCardTextStyle,
                                      ),
                                      Text(
                                        cryptocurrencyNames[selectedCryptocurrencies[i]].toString(),
                                        style: kCardSmallTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            SizedBox(
                              width: 100.0,
                              height: 90.0,
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  isVisible: false,
                                ),
                                primaryYAxis: NumericAxis(
                                  isVisible: false,
                                ),
                                plotAreaBorderWidth: 0,
                                series: <ChartSeries>[
                                  LineSeries<RealPrice, DateTime>(
                                    dataSource: getRealPrices(
                                        currency:
                                        selectedCryptocurrencies[i] + '-USD',
                                        number: 20),
                                    xValueMapper: (RealPrice data, _) =>
                                        DateTime.parse(data.date),
                                    yValueMapper: (RealPrice data, _) =>
                                    data.closePrice,
                                    color: realPriceList[i]
                                        .priceIncreasePercentage >
                                        0
                                        ? kGreen
                                        : kRed,
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$ ' +
                                      kDashboardPriceDisplay(realPriceList[i]
                                          .pricesList
                                          .last
                                          .closePrice),
                                  style: kCardSmallTextStyle,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      realPriceList[i]
                                          .priceIncreasePercentage >
                                          0
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: realPriceList[i]
                                          .priceIncreasePercentage >
                                          0
                                          ? kGreen
                                          : kRed,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                      child: Text(
                                        double.parse((realPriceList[i]
                                            .priceIncreasePercentage)
                                            .toStringAsFixed(2))
                                            .toString() +
                                            '%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Bierstadt',
                                          color: realPriceList[i]
                                              .priceIncreasePercentage >
                                              0
                                              ? kGreen
                                              : kRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CurrencyMarket(i, realPriceList);
                            }));
                      },
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
