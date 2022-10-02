import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';

final _firestore = FirebaseFirestore.instance;

Future<List<RealPrice>> getPricesOfACurrency(currency) async {
  List<RealPrice> priceList = [];
  final priceSnaps = await _firestore
      .collection('realPrices')
      .where('currency', isEqualTo: currency + '-USD')
      .get();
  for (var snap in priceSnaps.docs) {
    priceList.add(RealPrice(
        snap.data()['date'],
        snap.data()['openPrice'].toDouble(),
        snap.data()['closePrice'].toDouble(),
        snap.data()['highestPrice'].toDouble(),
        snap.data()['lowestPrice'].toDouble()));
  }
  return priceList;
}

Future<List<RealPricesOfACurrency>> getRealPriceData() async {
  List<RealPricesOfACurrency> allPricesLists =
      List<RealPricesOfACurrency>.filled(
          selectedCryptocurrencies.length, RealPricesOfACurrency(''));
  for (int i = 0; i < selectedCryptocurrencies.length; i++) {
    allPricesLists[i] =
        RealPricesOfACurrency('${selectedCryptocurrencies[i]}-USD');
  }

  try {
    List<Future> queries = [];
    for (int i = 0; i < selectedCryptocurrencies.length; i++) {
      queries.add(getPricesOfACurrency(selectedCryptocurrencies[i]));
    }
    final results = await Future.wait(queries);
    for (int i = 0; i < selectedCryptocurrencies.length; i++) {
      allPricesLists[i].pricesList = results[i];
      allPricesLists[i].calculatePriceIncreasePercentage();
    }

/*
    final priceSnaps = await _firestore.collection('realPrices').get();
    for (var snap in priceSnaps.docs) {
      for (int i = 0; i < cryptocurrencies.length; i++) {
        if (snap.data()['currency'] == '${cryptocurrencies[i]}-USD') {
          allPricesLists[i].pricesList.add(RealPrice(
              snap.data()['date'],
              snap.data()['openPrice'].toDouble(),
              snap.data()['closePrice'].toDouble(),
              snap.data()['highestPrice'].toDouble(),
              snap.data()['lowestPrice'].toDouble()));
          break;
        }
      }
    }

    for (int i = 0; i < cryptocurrencies.length; i++) {
      allPricesLists[i].calculatePriceIncreasePercentage();
    }*/
  } catch (e) {
    rethrow;
  }
  return allPricesLists;
}

class RealPricesOfACurrency {
  late String currency;
  late double priceIncreasePercentage = 0;
  late List<RealPrice> pricesList = [];

  RealPricesOfACurrency(this.currency);

  void calculatePriceIncreasePercentage() {
    priceIncreasePercentage = ((pricesList.last.closePrice -
                pricesList.elementAt(pricesList.length - 2).closePrice) /
            pricesList.elementAt(pricesList.length - 2).closePrice) *
        100;
  }
}

class RealPrice {
  late String date;
  late double openPrice, closePrice, highestPrice, lowestPrice;

  RealPrice(this.date, this.openPrice, this.closePrice, this.highestPrice,
      this.lowestPrice);
}

class GraphData {
  late dynamic valueOne;
  late dynamic valueTwo;

  GraphData({required this.valueOne, required this.valueTwo});
}
