import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';

import 'currency_future_predictions_graph.dart';

class CurrencyFuturePredictions extends StatefulWidget {
  const CurrencyFuturePredictions(
      this.currentUser, this.currencyIndex, this.realPriceList,
      {Key? key})
      : super(key: key);

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
        if (prediction.predictionCurrency == currency + '-USD') {
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  List<Prediction> getUserFuturePredictions({required String currency}) {
    List<Prediction> predictions = [];
    for (var p in currentUser.futurePredictions) {
      if (p.predictionCurrency == currency + '-USD') {
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
                  GestureDetector(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 45.0,
                                  child: Text(
                                    prediction.predictionDate,
                                    style: kCardTextStyle,
                                  ),
                                ),
                                IconButton(
                                  highlightColor: kRed,
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text(
                                            'Confirm Prediction Deletion\n',
                                            style: kInstructionStyle2,
                                          ),
                                          content: Text(
                                            "Do you want to delete the prediction made on "+prediction.predictedDate+"?\n"
                                                "\nPrediction currency: "+prediction.predictionCurrency+
                                                "\nPrediction date: "+prediction.predictionDate+
                                                "\nPrediction close price: \$ "+prediction.predictionClosePrice.toString()+
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

                                                currentUser.predictions.removeWhere((item) => item.predictionCurrency== prediction.predictionCurrency && item.predictionDate==prediction.predictionDate);
                                                currentUser.futurePredictions.removeWhere((item) => item.predictionCurrency== prediction.predictionCurrency && item.predictionDate==prediction.predictionDate);

                                                setState(()=>
                                                    getUserFuturePredictions(
                                                        currency: cryptocurrencies[widget.currencyIndex])
                                                );

                                                try {
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(widget.currentUser.user?.uid)
                                                      .collection('predictions')
                                                      .doc(prediction.predictionDate.toString().split(' ')[0] +
                                                      ' ' +
                                                      prediction.predictionCurrency)
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
                            const SizedBox(height: 10,),
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
                                const SizedBox(width: 20,),
                                RichText(
                                  text: TextSpan(
                                    text: 'Prediction Price\n',
                                    style: kCardSmallTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: prediction.predictionClosePrice.toString(),
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CurrencyFuturePredictionsGraph(widget.currencyIndex, widget.realPriceList, prediction);
                      }));
                    },

                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
