import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';

final _firestore = FirebaseFirestore.instance;
final String today=DateTime.now().toString().split(' ')[0];

Future<List<ForecastPrice>> getPricesOfACurrency(currency) async{
  List<ForecastPrice> priceList=[];
  final priceSnaps = await _firestore.collection('mlPredictions').doc('predictions').collection('predictionPrices')
      .where('currency',isEqualTo: currency+'-USD').where('date',isGreaterThanOrEqualTo: today).get();
  for (var snap in priceSnaps.docs) {
    priceList.add(ForecastPrice(
        snap.data()['date'],
        snap.data()['closePrice'].toDouble()));
  }
  return priceList;
}

Future<List<ForecastPricesOfACurrency>> getMLPredictionPriceData() async {

  List<ForecastPricesOfACurrency> allPricesLists =
  List<ForecastPricesOfACurrency>.filled(
      cryptocurrencies.length, ForecastPricesOfACurrency(''));
  for (int i = 0; i < cryptocurrencies.length; i++) {
    allPricesLists[i] = ForecastPricesOfACurrency('${cryptocurrencies[i]}-USD');
  }

  try {
    List<Future> queries=[];
    List<double> rsmes=[],rsmePercentages=[];
    for(int i=0;i<cryptocurrencies.length;i++){
      queries.add(getPricesOfACurrency(cryptocurrencies[i]));
      try{
        final errorDoc = await _firestore.collection('mlPredictions').doc('predictions').collection('predictionErrors')
            .doc('${cryptocurrencies[i]}-USD').get();
        rsmes.add(errorDoc.data()?['rsme'].toDouble());
        rsmePercentages.add(errorDoc.data()?['rsmePercentage'].toDouble());
      }catch(e){
        rethrow;
      }
    }
    final results=await Future.wait(queries);
    for(int i=0;i<cryptocurrencies.length;i++){
      allPricesLists[i].pricesList=results[i];
      allPricesLists[i].errorValue=rsmes[i];
      allPricesLists[i].errorPercentage=rsmePercentages[i];
    }
  } catch (e) {
    print(e);
  }
  return allPricesLists;
}

class ForecastPricesOfACurrency {
  late String currency;
  late double errorValue=0, errorPercentage=0;
  late List<ForecastPrice> pricesList = [];

  ForecastPricesOfACurrency(this.currency);
}

class ForecastPrice {
  late String date;
  late double closePrice;

  ForecastPrice(this.date, this.closePrice);
}