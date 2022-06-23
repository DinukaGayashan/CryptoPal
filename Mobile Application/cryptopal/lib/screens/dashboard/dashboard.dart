import 'package:cryptopal/screens/news/news_list_display.dart';
import 'package:cryptopal/screens/predictions/predictions.dart';
import 'package:cryptopal/screens/statistics/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/screens/initialization/welcome.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';
import 'package:cryptopal/screens/market/currency_market.dart';
import 'package:cryptopal/screens/news/news_display.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(this.currentUser, this.realPriceList, this.newsList,
      {Key? key})
      : super(key: key);
  static const String id = 'dashboard';
  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;
  final List<News> newsList;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;

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

  String getBestCryptocurrency() {
    double minError = double.infinity;
    int index = 0;
    for (int i = 0; i < cryptocurrencies.length; i++) {
      if (currentUser.errorVarianceOnCurrencies.values.elementAt(i) <
          minError) {
        minError = currentUser.errorVarianceOnCurrencies.values.elementAt(i);
        index = i;
      }
    }
    return minError.isNaN ? '-' : cryptocurrencyNames[index];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        /*appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 80.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Builder(builder: (context){
                return IconButton(
                  enableFeedback: true,
                  padding:
                  const EdgeInsets.only(left: 15, right: 20, top: 15, bottom: 20),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: kBaseColor2,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }
              ),
              Hero(
                tag: 'logo',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25.0,
                  child: Image.asset('assets/images/CryptoPal-logo-white.png'),
                ),
              ),
              const Hero(
                tag: 'name',
                child: Text(
                  "CryptoPal",
                  style: kTitleStyle,
                ),
              ),
              //const SizedBox(width: 50,)
            ],
          ),
        ),*/
        drawer: Drawer(
          backgroundColor: kTransparentColor4,
          child: ListView(

            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    enableFeedback: true,
                    padding:
                    const EdgeInsets.only(left: 30, right: 20, top: 30, bottom: 20),
                    icon: const Icon(Icons.close),
                    color: kBaseColor2,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              DrawerHeader(child: Center(child: Text(currentUser.name,style: kTopBarStyle,))),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Sign Out',style: kCardTextStyle,),
                onTap: (){
                  _auth.signOut();
                  SharedPreferences.getInstance().then(
                        (prefs) {
                      prefs.setBool("remember_me", false);
                    },
                  );
                  Navigator.pushReplacementNamed(
                      context, Welcome.id);
                },
                horizontalTitleGap: 5,
              ),
            ],
          ),
        ),
        body: LiquidPullToRefresh(
          backgroundColor: Colors.transparent,
          color: kBaseColor2,
          onRefresh: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, DashboardLoading.id, (route) => false);
          },
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: 80,
                      child: Builder(builder: (context){
                        return IconButton(
                          enableFeedback: true,
                          icon: const Icon(Icons.keyboard_control),
                          color: kBaseColor2,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      }
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Hero(
                          tag: 'logo',
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25.0,
                            child: Image.asset(
                                'assets/images/CryptoPal-logo-white.png'),
                          ),
                        ),
                        const Hero(
                          tag: 'name',
                          child: DefaultTextStyle(
                            child: Text(
                              'CryptoPal',
                            ),
                            style: kTitleStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 80,)
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                child: glassCard(
                  context,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Statistics',
                          style: kCardTitleStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 150.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'Average Error\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.error
                                              .roundToDouble()
                                              .toString(),
                                          style: kCardTextStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Error Deviation\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.standardDeviation
                                              .roundToDouble()
                                              .toString(),
                                          style: kCardTextStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Best Currency\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: getBestCryptocurrency(),
                                          style: kCardTextStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200.0,
                              width: 200.0,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: const AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: kBaseColor1,
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        color: kAccentColor1,
                                        animationType: AnimationType.ease,
                                        enableAnimation: true,
                                        value: currentUser.accuracy > 0
                                            ? currentUser.accuracy
                                                .roundToDouble()
                                            : 0,
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        positionFactor: 0.1,
                                        angle: 90,
                                        widget: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: currentUser.accuracy > 0
                                                    ? currentUser.accuracy
                                                        .round()
                                                        .toString()
                                                    : 'NaN',
                                                style: kCardNumberStyle,
                                                children: const <TextSpan>[
                                                  TextSpan(
                                                    text: '%',
                                                    style: kCardTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Text(
                                              'Accuracy',
                                              style: kCardTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Statistics(currentUser);
                  }));
                },
              ),
              GestureDetector(
                child: glassCard(
                  context,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Predictions',
                          style: kCardTitleStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'Total Predictions\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.predictions.length
                                              .toString(),
                                          style: kCardTextStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Past Predictions\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser
                                              .pastPredictions.length
                                              .toString(),
                                          style: kCardTextStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 70.0,
                                  width: 200.0,
                                  child: SfLinearGauge(
                                    orientation:
                                        LinearGaugeOrientation.vertical,
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    showAxisTrack: false,
                                    isMirrored: true,
                                    barPointers: [
                                      for (int i = currentUser
                                              .pastPredictions.length;
                                          i > 0 &&
                                              i >
                                                  currentUser.pastPredictions
                                                          .length -
                                                      10;
                                          i--)
                                        LinearBarPointer(
                                          enableAnimation: true,
                                          value: (currentUser
                                                      .pastPredictions[i - 1]
                                                      .errorPercentage
                                                      .abs()) >=
                                                  100.0
                                              ? 100.0
                                              : (currentUser
                                                  .pastPredictions[i - 1]
                                                  .errorPercentage
                                                  .abs()),
                                          color: currentUser
                                                      .pastPredictions[i - 1]
                                                      .errorPercentage >
                                                  0
                                              ? kGreen
                                              : kRed,
                                          edgeStyle: LinearEdgeStyle.bothCurve,
                                          offset: i * 10,
                                          position:
                                              LinearElementPosition.outside,
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      '             Past Errors',
                                      style: kCardSmallTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Predictions(currentUser, widget.realPriceList);
                  })).then((_) {
                    setState(() {
                      currentUser.predictions;
                      currentUser.futurePredictions;
                    });
                  });
                },
              ),
              glassCard(
                context,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Market',
                        style: kCardTitleStyle,
                      ),
                    ),
                    for (int i = 0; i < cryptocurrencies.length; i++)
                      GestureDetector(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const SizedBox(
                                width: 10.0,
                              ),
                              SvgPicture.asset(
                                'assets/images/cryptocoin_icons/color/' +
                                    cryptocurrencies[i].toLowerCase() +
                                    '.svg',
                                width: 35.0,
                                height: 35.0,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              SizedBox(
                                width: 80.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      cryptocurrencies[i],
                                      style: kCardTextStyle,
                                    ),
                                    Text(
                                      cryptocurrencyNames[i],
                                      style: kCardSmallTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              SizedBox(
                                width: 120.0,
                                height: 100.0,
                                child: charts.SfCartesianChart(
                                  primaryXAxis: charts.DateTimeAxis(
                                    isVisible: false,
                                  ),
                                  primaryYAxis: charts.NumericAxis(
                                    isVisible: false,
                                  ),
                                  plotAreaBorderWidth: 0,
                                  series: <charts.ChartSeries>[
                                    charts.LineSeries<RealPrice, DateTime>(
                                      dataSource: getRealPrices(
                                          currency:
                                              cryptocurrencies[i] + '-USD',
                                          number: 20),
                                      xValueMapper: (RealPrice data, _) =>
                                          DateTime.parse(data.date),
                                      yValueMapper: (RealPrice data, _) =>
                                          data.closePrice,
                                      color: widget.realPriceList[i]
                                                  .priceIncreasePercentage >
                                              0
                                          ? kGreen
                                          : kRed,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$ ' +
                                        kDashboardPriceDisplay(widget
                                                .realPriceList[i]
                                                .pricesList
                                                .last
                                                .closePrice)
                                            .toString(),
                                    style: kCardSmallTextStyle,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        widget.realPriceList[i]
                                                    .priceIncreasePercentage >
                                                0
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: widget.realPriceList[i]
                                                    .priceIncreasePercentage >
                                                0
                                            ? kGreen
                                            : kRed,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 60.0,
                                        child: Text(
                                          double.parse((widget.realPriceList[i]
                                                          .priceIncreasePercentage)
                                                      .toStringAsFixed(2))
                                                  .toString() +
                                              '%',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Bierstadt',
                                            color: widget.realPriceList[i]
                                                        .priceIncreasePercentage >
                                                    0
                                                ? kGreen
                                                : kRed,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CurrencyMarket(i, widget.realPriceList);
                          }));
                        },
                      ),
                  ],
                ),
              ),
              glassCard(
                context,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'News',
                        style: kCardTitleStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          for (var news in widget.newsList.getRange(0, 5))
                            GestureDetector(
                              child: SizedBox(
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: 96,
                                      child: Image.network(
                                        news.imageUrl.toString(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.source.toString(),
                                            style: kTransparentSmallStyle,
                                          ),
                                          Text(
                                            news.title.toString(),
                                            style: kCardSmallTextStyle,
                                          ),
                                          Text(
                                            news.date.toString().split('T')[0],
                                            style: kTransparentSmallStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return NewsDisplay(news);
                                }));
                              },
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return NewsListDisplay(widget.newsList);
                            }));
                          },
                          child: const Text(
                            'More News',
                            style: kLinkStyle,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
