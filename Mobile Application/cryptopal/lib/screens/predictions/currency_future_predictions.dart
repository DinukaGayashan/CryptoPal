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
  State<CurrencyFuturePredictions> createState() => _CurrencyFuturePredictionsState();
}

class _CurrencyFuturePredictionsState extends State<CurrencyFuturePredictions> {
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
                topBar(context, cryptocurrencyNames[widget.currencyIndex]+' Future Predictions',),
                const SizedBox(height: 20.0,),
                for(var x in getUserFuturePredictions(currency: cryptocurrencies[widget.currencyIndex]))
                  glassCard(context,
                    const Text('data'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
