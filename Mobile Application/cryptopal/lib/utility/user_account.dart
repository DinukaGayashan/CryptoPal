import 'dart:math';
import 'package:cryptopal/utility/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth=FirebaseAuth.instance;
final _firestore=FirebaseFirestore.instance;
late UserAccount currentUser=UserAccount();

Future<UserAccount> getActiveUserData() async {
  try{
    currentUser.user= _auth.currentUser;
  }
  catch(e){
    print(e);
  }

  try {
    final userSnapshot=await _firestore.collection('users').doc(currentUser.user?.uid).get();
    currentUser.name=userSnapshot.data()!['name'];
    currentUser.birthday=userSnapshot.data()!['birthday'].toDate();

    final predictionsWithoutErrorSnap=await _firestore.collection('users').doc(currentUser.user?.uid)
        .collection('predictions').where('errorPercentage', isEqualTo: null).get();
    for (var i in predictionsWithoutErrorSnap.docs) {
      try{
        final priceSnap=await _firestore.collection(i.data()['predictedCurrency'])
            .doc(i.data()['predictedDate']).get();
        double realPrice=priceSnap.data()!['closePrice'];
        double error=100*(i.data()['predictedClosePrice']-realPrice)/realPrice;
        await _firestore.collection('users').doc(currentUser.user?.uid)
            .collection('predictions').doc(i.id).set(
            {
              'errorPercentage':error,
            },
          SetOptions(merge: true)
        );
      }
      catch(e){
        print(e);
      }
    }

    try{
      final predictionsSnapshot=await _firestore.collection('users').doc(currentUser.user?.uid)
          .collection('predictions').get();
      for(var i in predictionsSnapshot.docs){
        currentUser.predictions.add(Prediction(
            i.data()['predictedDate'],
            i.data()['predictedCurrency'],
            i.data()['predictedClosePrice'],
            i.data()['errorPercentage']));
      }
    }catch(e){
      print(e);
    }

    try{
      int predictionCount=currentUser.predictions.length;
      double userError=0.0,userErrorVariance=0.0;
      List<double> userErrorsOnCurrencies=List<double>.filled(cryptocurrencies.length, 0);
      List<double> userErrorVarianceOnCurrencies=List<double>.filled(cryptocurrencies.length, 0);
      List<int> userPredictionsOnCurrencies=List<int>.filled(cryptocurrencies.length, 0);
      for(var i in currentUser.predictions){
        userError+=i.errorPercentage;
        userErrorVariance+=(i.errorPercentage*i.errorPercentage);
        for(int x=0; x<cryptocurrencies.length;x++){
          if(i.predictedCurrency==(cryptocurrencies[x]+"-USD")){
            userErrorsOnCurrencies[x]+=(i.errorPercentage);
            userErrorVarianceOnCurrencies[x]+=(i.errorPercentage*i.errorPercentage);
            userPredictionsOnCurrencies[x]++;
            break;
          }
        }
      }

      currentUser.error=userError/predictionCount;
      currentUser.variance=userErrorVariance/predictionCount;
      currentUser.standardDeviation=sqrt(currentUser.variance);
      for(int x=0; x<cryptocurrencies.length;x++){
        userErrorsOnCurrencies[x]/=userPredictionsOnCurrencies[x];
        userErrorVarianceOnCurrencies[x]/=userPredictionsOnCurrencies[x];
      }
      currentUser.errorsOnCurrencies=Map.fromIterables(cryptocurrencies,userErrorsOnCurrencies);
      currentUser.errorVarianceOnCurrencies=Map.fromIterables(cryptocurrencies,userErrorVarianceOnCurrencies);

      await _firestore.collection('users').doc(currentUser.user?.uid)
          .collection('predictions').doc('calculations').set(
          {
            'error':currentUser.error,
            'errorVariance':currentUser.variance,
            'errorStandardDeviation':currentUser.standardDeviation,
            'errorsOnCurrencies':currentUser.errorsOnCurrencies,
            'errorVarianceOnCurrencies':currentUser.errorVarianceOnCurrencies,
          },
      );
    }catch(e){
      print(e);
    }
  }
  catch(e){
    print(e);
  }
  return currentUser;
}

class Prediction{
  late String predictedDate;
  late String predictedCurrency;
  late double predictedClosePrice;
  late double errorPercentage;

  Prediction(this.predictedDate,this.predictedCurrency,this.predictedClosePrice,this.errorPercentage);
}

class UserAccount{
  late User? user;
  late String name;
  late DateTime birthday;
  late List<Prediction> predictions=[];
  late double error,variance,standardDeviation;
  late Map<String,double> errorsOnCurrencies;
  late Map<String,double> errorVarianceOnCurrencies;
}