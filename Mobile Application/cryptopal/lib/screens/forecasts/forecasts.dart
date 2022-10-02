import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/utility/forecast_price_data.dart';
import 'package:cryptopal/screens/forecasts/currency_forecasts.dart';

class Forecasts extends StatelessWidget {
  const Forecasts(this.realPriceList, this.forecastPriceList, {Key? key})
      : super(key: key);

  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> forecastPriceList;

  List<ForecastPrice> getForecastPrices(
      {required String currency, int number = 0}) {
    List<ForecastPrice> forecastPrices = [];
    for (var type in forecastPriceList) {
      if (type.currency == currency) {
        forecastPrices = type.pricesList;
        break;
      }
    }
    if (number != 0 && forecastPrices.length > number) {
      return forecastPrices.sublist(0, forecastPrices.length - number);
    }
    return forecastPrices;
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
            ListView(
              children: <Widget>[
                topBar(
                  context,
                  'Forecasts',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                for (int i = 0; i < selectedCryptocurrencies.length; i++)
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    child: glassCard(
                      context,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/cryptocoin_icons/color/${selectedCryptocurrencies[i].toLowerCase()}.svg',
                                  width: 45.0,
                                  height: 45.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      selectedCryptocurrencies[i],
                                      style: kCardTextStyle,
                                    ),
                                    Text(
                                      cryptocurrencyNames[
                                              selectedCryptocurrencies[i]]
                                          .toString(),
                                      style: kCardSmallTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100.0,
                            height: 90.0,
                            child: charts.SfCartesianChart(
                              primaryXAxis: charts.DateTimeAxis(
                                isVisible: false,
                              ),
                              primaryYAxis: charts.NumericAxis(
                                isVisible: false,
                              ),
                              plotAreaBorderWidth: 0,
                              series: <charts.ChartSeries>[
                                charts.LineSeries<ForecastPrice, DateTime>(
                                  dataSource: getForecastPrices(
                                      currency:
                                          '${selectedCryptocurrencies[i]}-USD',
                                      number: 20),
                                  xValueMapper: (ForecastPrice data, _) =>
                                      DateTime.parse(data.date),
                                  yValueMapper: (ForecastPrice data, _) =>
                                      data.closePrice,
                                  color: forecastPriceList[i].errorPercentage <
                                          10
                                      ? kGreen
                                      : forecastPriceList[i].errorPercentage <
                                              20
                                          ? kYellow
                                          : kRed,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Accuracy\n',
                              style: kTransparentSmallStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${(100 - forecastPriceList[i].errorPercentage).roundToDouble()}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Bierstadt',
                                    color: forecastPriceList[i]
                                                .errorPercentage <
                                            10
                                        ? kGreen
                                        : forecastPriceList[i].errorPercentage <
                                                20
                                            ? kYellow
                                            : kRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CurrencyForecasts(
                            realPriceList, forecastPriceList, i);
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
