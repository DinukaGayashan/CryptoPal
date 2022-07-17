import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cryptopal/screens/predictions/currency_predictions.dart';
import 'package:cryptopal/screens/predictions/add_prediction.dart';
import 'package:cryptopal/screens/predictions/future_predictions.dart';
import 'package:cryptopal/screens/predictions/past_predictions.dart';

class Predictions extends StatefulWidget {
  const Predictions(this.currentUser, this.realPriceList, {Key? key})
      : super(key: key);

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
        if (prediction.predictionCurrency == currency + '-USD') {
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor1,
        tooltip: 'Add Prediction',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddPrediction(currentUser,widget.realPriceList);
          })).then((_) {
            setState(() {
              currentUser.predictions;
              currentUser.futurePredictions;
            });
          });
        },
        child: const Icon(Icons.add,color: kTransparentColor4,),
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
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kTransparentColor1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: RichText(
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
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return PastPredictions(currentUser,
                                  widget.realPriceList);
                            }));
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kTransparentColor1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: RichText(
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
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return FuturePredictions(currentUser, widget.realPriceList);
                            })).then((_) {
                          setState(() {
                            currentUser.predictions;
                            currentUser.futurePredictions;
                          });
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                for (int i = 0; i < cryptocurrencies.length; i++)
                  InkWell(
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
                                        text: ((currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[i]]!) > 100?0:100-(currentUser.errorStandardDeviationOnCurrencies[cryptocurrencies[i]]!)
                                                    .roundToDouble())
                                            .toString()+'%',
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
                                    text: 'Average Error\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: (currentUser
                                                        .errorsOnCurrencies[
                                                    cryptocurrencies[i]] ??
                                                0)
                                            .roundToDouble()
                                            .toString()+'%',
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
