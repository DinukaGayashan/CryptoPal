import 'package:cryptopal/utility/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/forecast_price_data.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/screens/dashboard/dashboard.dart';

class DashboardLoading extends StatelessWidget {
  const DashboardLoading({Key? key}) : super(key: key);
  static const String id = 'DashboardLoading';

  // final _functions = FirebaseFunctions.instance;
  // final _firestore = FirebaseFirestore.instance;
  //
  // void addPastCryptoData() async {
  //   const int numberOfDaysBefore = 420;
  //   for (int i = 0; i < numberOfDaysBefore; i++) {
  //     print('addPastCryptoData call ${i + 1}');
  //     try {
  //       HttpsCallable addPastData =
  //           _functions.httpsCallable('addPastCryptoData');
  //       await addPastData
  //           .call(<String, dynamic>{'numberOfDays': 1, 'beforeDays': i});
  //     } catch (e) {
  //       print(e);
  //     }
  //     sleep(const Duration(minutes: 1));
  //   }
  // }
  //
  // void fixDatesOfPastCryptoData() async {
  //   final dataSnapshots = await _firestore.collection('realPrices').get();
  //   for (var data in dataSnapshots.docs) {
  //     try {
  //       final String dateString =
  //           data.data()['date'].toDate().toString().split(' ')[0];
  //       await _firestore.collection('realPrices').doc(data.id).set({
  //         'date': dateString,
  //       }, SetOptions(merge: true));
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future<List<News>> getData() {
    return compute(getNewsData, true);
  }

  void continueToDashboard(BuildContext context) async {
    UserAccount currentUser = UserAccount();
    List<RealPricesOfACurrency> realPriceList = [];
    List<ForecastPricesOfACurrency> mlForecastPriceList = [];
    List<News> newsList = [];

    Stopwatch stopwatchx = Stopwatch()..start();

    Stopwatch stopwatch = Stopwatch()..start();
    await loadCryptocurrencyData();
    stopwatch.stop();
    print('crypto done in ${stopwatch.elapsed}');

    stopwatch.reset();
    stopwatch.start();
    currentUser = await getActiveUserData();
    stopwatch.stop();
    print('user done in ${stopwatch.elapsed}');

    stopwatch.reset();
    stopwatch.start();
    newsList = await getData();
    stopwatch.stop();
    print('news done in ${stopwatch.elapsed}');

    stopwatch.reset();
    stopwatch.start();
    realPriceList = await getRealPriceData();
    stopwatch.stop();
    print('real data done in ${stopwatch.elapsed}');

    stopwatch.reset();
    stopwatch.start();
    mlForecastPriceList = await getMLForecastPriceData();
    stopwatch.stop();
    print('ml data done in ${stopwatch.elapsed}');

    stopwatchx.stop();
    print('loading done in ${stopwatchx.elapsed}');

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Dashboard(
          currentUser, realPriceList, mlForecastPriceList, newsList);
    }));
  }

  @override
  Widget build(BuildContext context) {
    try {
      continueToDashboard(context);
    } catch (e) {
      snackBar(context, message: e.toString(), color: kRed);
    }
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
                        child: DefaultTextStyle(
                          style: kMainTitleStyle,
                          child: Text(
                            'CryptoPal',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
                child: Center(
                  child: Hero(
                    tag: 'description',
                    child: DefaultTextStyle(
                      style: kInstructionStyle,
                      child: Text(
                        'Advisory platform for cryptocurrency investments',
                      ),
                    ),
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
