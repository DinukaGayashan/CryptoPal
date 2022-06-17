import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';

class CurrencyFuturePredictions extends StatefulWidget {
  const CurrencyFuturePredictions(
      this.currentUser, this.currencyIndex, this.realPriceList,
      {Key? key})
      : super(key: key);

  static const String id = 'CurrencyPastPredictions';
  final UserAccount currentUser;
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<CurrencyFuturePredictions> createState() =>
      _CurrencyFuturePredictionsState();
}

class _CurrencyFuturePredictionsState extends State<CurrencyFuturePredictions> {

  final _firestore = FirebaseFirestore.instance;

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

  List<Prediction> getUserFuturePredictions({required String currency}) {
    List<Prediction> predictions = [];
    for (var p in currentUser.futurePredictions) {
      if (p.predictedCurrency == currency + '-USD') {
        predictions.add(p);
      }
    }
    return predictions;
  }

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
    final List<RealPrice> priceList =
        getRealPrices(currency: currency + '-USD');
    RealPrice x = RealPrice(date, 0, 0, 0, 0);
    for (var i in priceList) {
      if (i.date == date) {
        x = i;
      }
    }
    return x;
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
                  cryptocurrencyNames[widget.currencyIndex] +
                      ' Future Predictions',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                for (var prediction in getUserFuturePredictions(
                    currency: cryptocurrencies[widget.currencyIndex]))
                  glassCard(
                    context,
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 45.0,
                                  child: Text(
                                    prediction.predictedDate,
                                    style: kCardTextStyle,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Predicted Price\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: prediction.predictedClosePrice.toString(),
                                        style: kCardTextStyle2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              highlightColor: kRed,
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: kBackgroundColor,
                                      title: const Text(
                                        'Delete Prediction',
                                        style: kInstructionStyle2,
                                      ),
                                      content: Text(
                                        "Do you want to delete the prediction?\n"
                                            "\nPredicted currency: "+prediction.predictedCurrency+
                                            "\nPredicted date: "+prediction.predictedDate+
                                            "\nPredicted close price: \$ "+prediction.predictedClosePrice.toString()+
                                        "\n\nThis cannot be undone.",
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

                                              currentUser.predictions.removeWhere((item) => item.predictedCurrency== prediction.predictedCurrency && item.predictedDate==prediction.predictedDate);
                                              currentUser.futurePredictions.removeWhere((item) => item.predictedCurrency== prediction.predictedCurrency && item.predictedDate==prediction.predictedDate);

                                              setState(()=>
                                                getUserFuturePredictions(
                                                    currency: cryptocurrencies[widget.currencyIndex])
                                              );

                                            try {
                                              await _firestore
                                                  .collection('users')
                                                  .doc(widget.currentUser.user?.uid)
                                                  .collection('predictions')
                                                  .doc(prediction.predictedDate.toString().split(' ')[0] +
                                                  ' ' +
                                                  prediction.predictedCurrency)
                                                  .delete();
                                              snackBar(context, message: 'Prediction successfully deleted.', color: kGreen);
                                            } catch (e) {
                                              snackBar(context,message: e.toString(),color: kRed);
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
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
