import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:cryptopal/screens/predictions/currency_prediction_graph.dart';

class FuturePredictions extends StatefulWidget {
  const FuturePredictions(this.currentUser, this.realPriceList, {Key? key})
      : super(key: key);

  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<FuturePredictions> createState() => _FuturePredictionsState();
}

class _FuturePredictionsState extends State<FuturePredictions> {
  final _firestore = FirebaseFirestore.instance;

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
                  'Future Predictions',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                for (var prediction in currentUser.futurePredictions)
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    child: glassCard(
                      context,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 60.0,
                                  child: Text(
                                    '${prediction.predictionDate}\n${prediction.predictionCurrency}',
                                    style: kCardLargeTextStyle,
                                  ),
                                ),
                                IconButton(
                                  highlightColor: kRed,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: kBackgroundColor,
                                          title: const Text(
                                            'Confirm Prediction Deletion',
                                            style: kInstructionStyle2,
                                          ),
                                          content: Text(
                                            "Do you want to delete the prediction made on ${prediction.predictedDate}?\n"
                                            "\nPrediction currency: ${prediction.predictionCurrency}"
                                            "\nPrediction date: ${prediction.predictionDate}"
                                            "\nPrediction close price: \$ ${prediction.predictionClosePrice}\n"
                                            "\nThis cannot be undone.",
                                            style: kInstructionStyle,
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text(
                                                "Cancel",
                                                style: kLinkStyle,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                "Delete",
                                                style: kLinkStyle,
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                currentUser.predictions
                                                    .removeWhere((item) =>
                                                        item.predictionCurrency ==
                                                            prediction
                                                                .predictionCurrency &&
                                                        item.predictionDate ==
                                                            prediction
                                                                .predictionDate);
                                                currentUser.futurePredictions
                                                    .removeWhere((item) =>
                                                        item.predictionCurrency ==
                                                            prediction
                                                                .predictionCurrency &&
                                                        item.predictionDate ==
                                                            prediction
                                                                .predictionDate);
                                                setState(() {
                                                  currentUser.futurePredictions;
                                                  currentUser.predictions;
                                                });

                                                try {
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(widget
                                                          .currentUser.user.uid)
                                                      .collection('predictions')
                                                      .doc(
                                                          '${prediction.predictionDate.toString().split(' ')[0]} ${prediction.predictionCurrency}')
                                                      .delete();
                                                  snackBar(context,
                                                      message:
                                                          'Prediction successfully deleted.',
                                                      color: kGreen);
                                                } catch (e) {
                                                  snackBar(context,
                                                      message: e.toString(),
                                                      color: kRed);
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                  color: kRed,
                                  tooltip: 'Delete Prediction',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
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
                                  width: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Prediction Price\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${prediction.predictionClosePrice} \$',
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
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
