import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'dashboard.dart';

final _functions = FirebaseFunctions.instance;

class DashboardLoading extends StatefulWidget {
  const DashboardLoading({Key? key}) : super(key: key);
  static const String id = 'DashboardLoading';

  @override
  State<DashboardLoading> createState() => _DashboardLoadingState();
}

class _DashboardLoadingState extends State<DashboardLoading> {
  late UserAccount currentUser = UserAccount();
  late List<RealPricesOfACurrency> realPriceList;
  late List<News> news = [];

  void loadUser() async {
    currentUser = await getActiveUserData();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Dashboard(currentUser, realPriceList, news);
    }));
  }

  void loadData() async {
    realPriceList = await getRealPriceData();
  }

  void loadNews() async {
    news = await getNewsData();
  }

  void addPastCryptoData() async {
    const int numberOfDaysBefore = 32;
    for (int i = 0; i < numberOfDaysBefore; i++) {
      print('addPastCryptoData call ' + (i + 1).toString());
      try {
        HttpsCallable addPastData =
            _functions.httpsCallable('addPastCryptoData');
        await addPastData
            .call(<String, dynamic>{'numberOfDays': 1, 'beforeDays': i});
      } catch (e) {
        print(e);
      }
      sleep(const Duration(minutes: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    //addPastCryptoData();
    loadNews();
    loadData();
    loadUser();

    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 100.0,
                      child:
                          Image.asset('assets/images/CryptoPal-logo-white.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: Center(
                      child: Hero(
                        tag: 'name',
                        child: Text(
                          'CryptoPal',
                          style: kMainTitleStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
                child: Center(
                  child: Text(
                    'Advisory platform for cryptocurrency investments',
                    style: kInstructionStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              const SizedBox(
                child: SpinKitFoldingCube(
                  size: 50.0,
                  color: kBaseColor2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
