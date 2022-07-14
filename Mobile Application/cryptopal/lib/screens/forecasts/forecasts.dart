import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import '../../utility/forecast_price_data.dart';
import 'currency_forecasts.dart';

class Forecasts extends StatelessWidget {
  const Forecasts(this.realPriceList, this.forecastPriceList, {Key? key}) : super(key: key);

  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> forecastPriceList;

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
                  'Forecasts',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                for(int i=0;i<cryptocurrencies.length;i++)
                  GestureDetector(
                    child: glassCard(
                      context,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/cryptocoin_icons/color/' +
                                      cryptocurrencies[i].toLowerCase() +
                                      '.svg',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  cryptocurrencies[i],
                                  style: kCardTextStyle,
                                ),
                                Text(
                                  cryptocurrencyNames[i],
                                  style: kCardSmallTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            SizedBox(
                              width: 120.0,
                              height: 100.0,
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  isVisible: false,
                                ),
                                primaryYAxis: NumericAxis(
                                  isVisible: false,
                                ),
                                plotAreaBorderWidth: 0,
                                series: <ChartSeries>[
                                  LineSeries<ForecastPrice, DateTime>(
                                    dataSource: getForecastPrices(
                                        currency:
                                        cryptocurrencies[i] + '-USD',
                                        number: 20),
                                    xValueMapper: (ForecastPrice data, _) =>
                                        DateTime.parse(data.date),
                                    yValueMapper: (ForecastPrice data, _) =>
                                    data.closePrice,
                                    color: kAccentColor1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CurrencyForecasts(realPriceList,forecastPriceList,i);
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
    );
  }
}

