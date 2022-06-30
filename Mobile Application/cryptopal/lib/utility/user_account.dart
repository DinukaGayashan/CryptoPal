import 'dart:math';
import 'package:cryptopal/utility/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
late UserAccount currentUser = UserAccount();
final String today=DateTime.now().toString().split(' ')[0];

Future<UserAccount> getActiveUserData() async {

  try {
    currentUser.user = _auth.currentUser;
  } catch (e) {

  }

  try {
    final userSnapshot =
        await _firestore.collection('users').doc(currentUser.user?.uid).get();
    currentUser.name = userSnapshot.data()!['name'];
    currentUser.birthday = userSnapshot.data()!['birthday'];

    final predictionsWithoutErrorSnap = await _firestore
        .collection('users')
        .doc(currentUser.user?.uid)
        .collection('predictions')
        .where('errorPercentage', isEqualTo: null)
        .get();
    for (var i in predictionsWithoutErrorSnap.docs) {
      try {
        final priceSnap = await _firestore.collection('realPrices')
            .doc(i.data()['predictionDate']+' '+i.data()['predictionCurrency'])
            .get();

        double realPrice = priceSnap.data()!['closePrice'].toDouble();
        double errorValue =
            (i.data()['predictionClosePrice'].toDouble() - realPrice);
        double errorPercentage =
            100 * errorValue / realPrice;

        await _firestore
            .collection('users')
            .doc(currentUser.user?.uid)
            .collection('predictions')
            .doc(i.id)
            .set({
          'errorValue':errorValue.toDouble(),
          'errorPercentage': errorPercentage.toDouble(),
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }

    try {
      final predictionsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.user?.uid)
          .collection('predictions')
          .get();
      currentUser.predictions.clear();
      currentUser.pastPredictions.clear();
      currentUser.futurePredictions.clear();
      for (var i in predictionsSnapshot.docs) {
        if(i.data()['errorPercentage']!=null){
          currentUser.pastPredictions.add(Prediction(
              i.data()['predictedDate'],
              i.data()['predictionDate'],
              i.data()['predictionCurrency'],
              i.data()['predictionClosePrice'].toDouble(),
              i.data()['errorValue'].toDouble(),
              i.data()['errorPercentage'].toDouble()));
        }
        else{
          currentUser.futurePredictions.add(Prediction(
              i.data()['predictedDate'],
              i.data()['predictionDate'],
              i.data()['predictionCurrency'],
              i.data()['predictionClosePrice'].toDouble(),
              0.0,0.0));
        }
        currentUser.predictions.add(Prediction(
            i.data()['predictedDate'],
            i.data()['predictionDate'],
            i.data()['predictionCurrency'],
            i.data()['predictionClosePrice'].toDouble(),
            0.0,0.0));
      }
    } catch (e) {
      print(e);
    }

    try {
      int predictionCount = currentUser.pastPredictions.length;
      double userError = 0.0, userErrorVariance = 0.0;
      List<double> userErrorsOnCurrencies =
          List<double>.filled(cryptocurrencies.length, 0);
      List<double> userErrorVarianceOnCurrencies =
          List<double>.filled(cryptocurrencies.length, 0);
      List<int> userPredictionsOnCurrencies =
          List<int>.filled(cryptocurrencies.length, 0);
      for (var i in currentUser.pastPredictions) {
        userError += i.errorPercentage;
        userErrorVariance += (i.errorPercentage * i.errorPercentage);
        for (int x = 0; x < cryptocurrencies.length; x++) {
          if (i.predictionCurrency == (cryptocurrencies[x] + "-USD")) {
            userErrorsOnCurrencies[x] += (i.errorPercentage);
            userErrorVarianceOnCurrencies[x] +=
                (i.errorPercentage * i.errorPercentage);
            userPredictionsOnCurrencies[x]++;
            break;
          }
        }
      }

      List<double> userErrorStandardDeviationOnCurrencies =
      List<double>.filled(cryptocurrencies.length, 0);

      currentUser.error = userError / predictionCount;
      currentUser.errorVariance = userErrorVariance / predictionCount;
      currentUser.errorStandardDeviation = sqrt(currentUser.errorVariance);
      for (int x = 0; x < cryptocurrencies.length; x++) {
        userErrorsOnCurrencies[x] /= userPredictionsOnCurrencies[x];
        userErrorVarianceOnCurrencies[x] /= userPredictionsOnCurrencies[x];
        userErrorStandardDeviationOnCurrencies[x]=sqrt(userErrorVarianceOnCurrencies[x]);
      }

      currentUser.errorsOnCurrencies =
          Map.fromIterables(cryptocurrencies, userErrorsOnCurrencies);
      currentUser.errorVarianceOnCurrencies =
          Map.fromIterables(cryptocurrencies, userErrorVarianceOnCurrencies);
      currentUser.errorStandardDeviationOnCurrencies=
          Map.fromIterables(cryptocurrencies, userErrorStandardDeviationOnCurrencies);

      currentUser.accuracy =
          100 - currentUser.errorStandardDeviation;

      await _firestore
          .collection('users')
          .doc(currentUser.user?.uid)
          .collection('statistics')
          .doc('calculations')
          .set(
        {
          'accuracy':currentUser.accuracy,
          'error': currentUser.error,
          'errorVariance': currentUser.errorVariance,
          'errorStandardDeviation': currentUser.errorStandardDeviation,
          'errorsOnCurrencies': currentUser.errorsOnCurrencies,
          'errorVarianceOnCurrencies': currentUser.errorVarianceOnCurrencies,
          'errorStandardDeviationOnCurrencies': currentUser.errorStandardDeviationOnCurrencies,
        },
      );

      await _firestore
          .collection('users')
          .doc(currentUser.user?.uid)
          .collection('statistics')
          .doc('pastCalculations')
          .set(
          {
            'accuracyHistory':{today:currentUser.accuracy},
            'errorHistory': {today:currentUser.error},
            'errorVarianceHistory': {today:currentUser.errorVariance},
            'errorStandardDeviationHistory': {today:currentUser.errorStandardDeviation},
            'errorsOnCurrenciesHistory': {today:currentUser.errorsOnCurrencies},
            'errorVarianceOnCurrenciesHistory': {today:currentUser.errorVarianceOnCurrencies},
          }, SetOptions(merge: true));

      final historySnapshot = await _firestore
          .collection('users')
          .doc(currentUser.user?.uid)
          .collection('statistics')
          .doc('pastCalculations')
          .get();

      currentUser.history={};
      final Map<String,dynamic> accuracyHistory=historySnapshot['accuracyHistory'];
      final Map<String,dynamic> errorHistory=historySnapshot['errorHistory'];
      final Map<String,dynamic> errorStandardDeviationHistory=historySnapshot['errorStandardDeviationHistory'];
      final Map<String,dynamic> errorVarianceHistory=historySnapshot['errorVarianceHistory'];
      final List<dynamic> historyDates=accuracyHistory.keys.toList();
      for(int i=0;i<historyDates.length;i++){
        final Map<String, dynamic> errorsOnCurrenciesHistory=historySnapshot['errorsOnCurrenciesHistory'][historyDates.elementAt(i)];
        final Map<String, dynamic> errorVarianceOnCurrenciesHistory=historySnapshot['errorVarianceOnCurrenciesHistory'][historyDates.elementAt(i)];
        currentUser.history[historyDates.elementAt(i)]=DayHistory(accuracyHistory[historyDates.elementAt(i)], errorHistory[historyDates.elementAt(i)], errorVarianceHistory[historyDates.elementAt(i)], errorStandardDeviationHistory[historyDates.elementAt(i)], errorsOnCurrenciesHistory, errorVarianceOnCurrenciesHistory);
      }
    } catch (e) {
      print(e);
    }
  } catch (e) {
    print(e);
  }
  return currentUser;
}

class DayHistory{
  late double accuracy, error, variance, standardDeviation;
  late Map<String, dynamic> errorsOnCurrencies, errorVarianceOnCurrencies;

  DayHistory(this.accuracy,this.error,this.variance,this.standardDeviation,this.errorsOnCurrencies,this.errorVarianceOnCurrencies);
}

class Prediction {
  late String predictedDate;
  late String predictionDate;
  late String predictionCurrency;
  late double predictionClosePrice;
  late double errorValue;
  late double errorPercentage;
  late DateTime predictionDateAsDate;

  Prediction(this.predictedDate, this.predictionDate, this.predictionCurrency,
      this.predictionClosePrice, this.errorValue,this.errorPercentage){
    predictionDateAsDate=DateTime.parse(predictionDate);
  }

  List<Prediction> toList(Prediction x){
    List<Prediction> list=[];
    list.add(Prediction(x.predictedDate, x.predictionDate, x.predictionCurrency, x.predictionClosePrice,x.errorValue, x.errorPercentage));
    return list;
  }
}

class UserAccount {
  late User? user;
  late String name, birthday;
  late List<Prediction> predictions = [], pastPredictions = [], futurePredictions = [];
  late double error, errorVariance, errorStandardDeviation, accuracy;
  late Map<String, double> errorsOnCurrencies, errorVarianceOnCurrencies,errorStandardDeviationOnCurrencies;
  late Map<String, DayHistory> history;
}
