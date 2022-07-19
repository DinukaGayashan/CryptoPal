import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

List<String> selectedCryptocurrencies=[];

List<String> cryptocurrencies = [];

Map<String,String> cryptocurrencyNames = {};

Future<void> loadCryptocurrencyData()async{
  final cryptoSnap=await _firestore.collection('cryptocurrencies').get();
  for(var crypto in cryptoSnap.docs){
    cryptocurrencies.add(crypto.data()['id']);
    cryptocurrencyNames[crypto.data()['id']]=crypto.data()['name'];
  }
}

