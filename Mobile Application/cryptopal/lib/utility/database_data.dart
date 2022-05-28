import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';

final _firestore = FirebaseFirestore.instance;

Future<List<RealPricesOfACurrency>> getRealPriceData() async {

  List<RealPricesOfACurrency> allPricesLists = List<RealPricesOfACurrency>.filled(cryptocurrencies.length, RealPricesOfACurrency(''));
  for(int i=0;i<cryptocurrencies.length;i++){
    allPricesLists[i] = RealPricesOfACurrency(cryptocurrencies[i]+'-USD');
  }

  try{
    final priceSnaps = await _firestore.collection('realPrices').get();
    for(var snap in priceSnaps.docs){
      for(int i=0;i<cryptocurrencies.length;i++){
        if(snap.data()['currency']==cryptocurrencies[i]+'-USD'){
          allPricesLists[i].pricesList.add(RealPrice(snap.data()['date'],snap.data()['openPrice'].toDouble(),snap.data()['closePrice'].toDouble(),snap.data()['highestPrice'].toDouble(),snap.data()['lowestPrice'].toDouble()));
          break;
        }
      }
    }
  }
  catch(e){
    print(e);
  }
  return allPricesLists;
}

class RealPricesOfACurrency{
  late String currency;
  late List<RealPrice> pricesList=[];

  RealPricesOfACurrency(this.currency);
}

class RealPrice{
  late String date;
  late double openPrice;
  late double closePrice;
  late double highestPrice;
  late double lowestPrice;

  RealPrice(this.date,this.openPrice,this.closePrice,this.highestPrice,this.lowestPrice);
}