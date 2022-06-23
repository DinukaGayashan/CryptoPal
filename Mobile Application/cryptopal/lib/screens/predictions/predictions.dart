import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'currency_predictions.dart';
import 'add_prediction.dart';

class Predictions extends StatefulWidget {
  const Predictions(this.currentUser, this.realPriceList, {Key? key})
      : super(key: key);

  static const String id = 'Predictions';
  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<Predictions> createState() => _PredictionsState();
}

class _PredictionsState extends State<Predictions> {
  List<Prediction> getUserPredictions(
      {required String currency, bool past = false}) {
    List<Prediction> predictions = [];
    List<Prediction> predictionSnap =
        past ? currentUser.pastPredictions : currentUser.predictions;
    if (currency == 'all') {
      predictions = predictionSnap;
    } else {
      for (var prediction in predictionSnap) {
        if (prediction.predictedCurrency == currency + '-USD') {
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor1,
        child: const Icon(Icons.add),
        tooltip: 'Add Prediction',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddPrediction(currentUser);
          })).then((_) {
            setState(() {
              currentUser.predictions;
              currentUser.futurePredictions;
            });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(
                  context,
                  'Predictions',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Total Predictions\n',
                    style: kCardTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: currentUser.predictions.length.toString(),
                        style: kCardTextStyle3,
                      ),
                    ],
                  ),
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Tooltip(
                      message: 'Add Prediction',
                      child: FloatingActionButton(
                        backgroundColor: kAccentColor1,
                        child: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddPrediction(currentUser);
                          }));
                        },
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Past Predictions\n',
                        style: kCardSmallTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: currentUser.pastPredictions.length.toString(),
                            style: kCardTextStyle2,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Future Predictions\n',
                        style: kCardSmallTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: (currentUser.futurePredictions.length)
                                .toString(),
                            style: kCardTextStyle2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                for (int i = 0; i < cryptocurrencies.length; i++)
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Predictions\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: getUserPredictions(
                                                currency: cryptocurrencies[i])
                                            .length
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Accuracy\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ((currentUser.errorsOnCurrencies[
                                                            cryptocurrencies[
                                                                i]]!)
                                                        .abs() >
                                                    100
                                                ? 0
                                                : (currentUser.errorsOnCurrencies[
                                                            cryptocurrencies[
                                                                i]]! -
                                                        (currentUser.errorsOnCurrencies[
                                                                    cryptocurrencies[
                                                                        i]]! >
                                                                0
                                                            ? 100
                                                            : -100))
                                                    .abs()
                                                    .roundToDouble())
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Past Predictions\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: getUserPredictions(
                                                currency: cryptocurrencies[i],
                                                past: true)
                                            .length
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Error Deviation\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: sqrt(currentUser
                                                        .errorVarianceOnCurrencies[
                                                    cryptocurrencies[i]] ??
                                                0)
                                            .roundToDouble()
                                            .toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CurrencyPredictions(
                              currentUser,
                              i,
                              widget.realPriceList,
                            );
                          })).then((_) {
                        setState(() {
                          currentUser.predictions;
                          currentUser.futurePredictions;
                        });
                      });
                    },
                  ),
                const SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
