import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/screens/predictions/currency_prediction_graph.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';

class PastPredictions extends StatefulWidget {
  const PastPredictions(this.currentUser, this.realPriceList, {Key? key})
      : super(key: key);

  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<PastPredictions> createState() => _PastPredictionsState();
}

class _PastPredictionsState extends State<PastPredictions> {
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

  RealPrice? getRealPrice({required String currency, required String date}) {
    final List<RealPrice> priceList = getRealPrices(currency: '$currency-USD');
    RealPrice x = RealPrice(date, 0, 0, 0, 0);
    for (var i in priceList) {
      if (i.date == date) {
        x = i;
      }
    }
    return x;
  }

  int getCryptocurrencyIndex(String predictionCurrency) {
    int i = 0;
    for (i = 0; i < selectedCryptocurrencies.length; i++) {
      if (selectedCryptocurrencies[i] == predictionCurrency.split('-')[0]) {
        break;
      }
    }
    return i;
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
                  'Past Predictions',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                for (var prediction in currentUser.pastPredictions.reversed)
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    child: glassCard(
                      context,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 70,
                                      child: Text(
                                        '${prediction.predictionDate}\n${prediction.predictionCurrency}',
                                        style: kCardLargeTextStyle,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Predicted On\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: prediction.predictedDate,
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Price when predicted\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${kCurrencyPriceDisplay(getRealPrice(currency: prediction.predictionCurrency.split('-')[0], date: prediction.predictedDate)?.closePrice)} \$',
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Accuracy\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${(100 - sqrt(prediction.errorPercentage * prediction.errorPercentage)).roundToDouble()}%',
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 70,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Prediction Price\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${kCurrencyPriceDisplay(prediction.predictionClosePrice)} \$',
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Actual Price\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${kCurrencyPriceDisplay(getRealPrice(currency: selectedCryptocurrencies[getCryptocurrencyIndex(prediction.predictionCurrency)], date: prediction.predictionDate)?.closePrice)} \$',
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Error\n',
                                        style: kCardSmallTextStyle,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${kCurrencyPriceDisplay(prediction.errorValue)} \$',
                                            style: kCardTextStyle2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            prediction.predictionKeywords != null
                                ? HashTagText(
                                    text: '\n${prediction.predictionKeywords}',
                                    basicStyle: kTransparentStyle,
                                    decoratedStyle: kCardSmallTextStyle)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CurrencyPredictionGraph(
                            getCryptocurrencyIndex(
                                prediction.predictionCurrency),
                            widget.realPriceList,
                            prediction);
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
