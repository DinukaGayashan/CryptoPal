import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:glass/glass.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';
import 'package:cryptopal/screens/market/currency_market.dart';
import 'package:cryptopal/screens/news/news_display.dart';
import 'package:cryptopal/screens/news/news_list_display.dart';
import 'package:cryptopal/screens/predictions/predictions.dart';
import 'package:cryptopal/screens/statistics/statistics.dart';

import '../../utility/forecast_price_data.dart';
import '../forecasts/forecasts.dart';
import '../market/market.dart';
import '../predictions/add_prediction.dart';
import '../settings/settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(this.currentUser, this.realPriceList,
      this.mlPredictionPriceList, this.newsList,
      {Key? key})
      : super(key: key);

  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> mlPredictionPriceList;
  final List<News> newsList;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

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
    for (int i = 0; i < selectedCryptocurrencies.length; i++) {
      if (currentUser.errorVarianceOnCurrencies.values.elementAt(i) <
          minError) {
        minError = currentUser.errorVarianceOnCurrencies.values.elementAt(i);
        index = i;
      }
    }
    return minError.isInfinite ? '-' : cryptocurrencyNames[selectedCryptocurrencies[index]].toString();
  }

  int getAverageForecastDays(){
    int days=0;
    for (int i = 0; i < selectedCryptocurrencies.length; i++) {
      days+=widget.mlPredictionPriceList[i].pricesList.length;
    }
    return (days/selectedCryptocurrencies.length).round();
  }

  double getAverageForecastError(){
    double error=0;
    for (int i = 0; i < selectedCryptocurrencies.length; i++) {
      error+=widget.mlPredictionPriceList[i].errorPercentage;
    }
    return error/selectedCryptocurrencies.length;
  }

  List<T> pickRandomItemsAsList<T>(List<T> items, int count) =>
      (items.toList()..shuffle()).take(count).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            backgroundColor: kBaseColor1,
            /*drawer: Drawer(
              backgroundColor: kTransparentColor4,
              width: MediaQuery.of(context).size.width * 0.72,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        enableFeedback: true,
                        padding: const EdgeInsets.only(
                            left: 30, right: 20, top: 30, bottom: 20),
                        icon: const Icon(Icons.close),
                        color: kBaseColor2,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  DrawerHeader(
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: currentUser.name + '\n',
                          style: kCardTitleStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: currentUser.user?.email.toString(),
                              style: kTransparentStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.manage_accounts_rounded),
                    title: const Text(
                      'Account',
                      style: kCardTextStyle,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                            return Account(
                              currentUser,
                            );
                          })).then((_) {
                        setState(() {
                          currentUser.name;
                          currentUser.birthday;
                        });
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text(
                      'Settings',
                      style: kCardTextStyle,
                    ),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text(
                      'Help',
                      style: kCardTextStyle,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                            return const Help();
                          }));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.touch_app),
                    title: const Text(
                      'About App',
                      style: kCardTextStyle,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                            return const AboutApp();
                          }));
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height-600,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 15.0,
                        child: Image.asset(
                            'assets/images/CryptoPal-logo-white.png'),
                      ),
                      DefaultTextStyle(
                        style: kSmallTitleStyle,
                        child: Text(
                          'CryptoPal',
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    version,
                    style: kTransparentSmallStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).asGlass(),*/
            body: LiquidPullToRefresh(
              color: Colors.transparent,
              backgroundColor: Colors.transparent,
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
                        /*child: Builder(builder: (context) {
                          return IconButton(
                            enableFeedback: true,
                            icon: const Icon(Icons.keyboard_control),
                            color: kBaseColor2,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }),*/
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25.0,
                            child: Image.asset(
                                'assets/images/CryptoPal-logo-white.png'),
                          ),
                          const DefaultTextStyle(
                            style: kTitleStyle,
                            child: Text(
                              'CryptoPal',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                        child: IconButton(
                          enableFeedback: true,
                          icon: const Icon(Icons.keyboard_control),
                          color: kBaseColor2,
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                                  return Settings(
                                    currentUser,
                                  );
                                })).then((_) {
                              setState(() {
                                currentUser.name;
                                currentUser.birthday;
                              });
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
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
                                              text: 'Error Deviation\n',
                                              style: kCardSmallTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: currentUser
                                                      .errorStandardDeviation
                                                      .roundToDouble()
                                                      .toString() +
                                                      '%',
                                                  style: kCardTextStyle2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Average Error\n',
                                              style: kCardSmallTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: '${currentUser.error
                                                      .roundToDouble()}%',
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
                                      height: 190.0,
                                      width: 190.0,
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Statistics(currentUser, widget.realPriceList);
                              }));
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
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
                                    currentUser.pastPredictions.isEmpty
                                        ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 40.0),
                                          child: SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: MaterialButton(
                                              color: kAccentColor1,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16.0),
                                              ),
                                              //borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              // backgroundColor: kAccentColor1,
                                              // tooltip: 'Add Prediction',
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                          return AddPrediction(
                                                              currentUser,
                                                              widget.realPriceList);
                                                        })).then((_) {
                                                  setState(() {
                                                    currentUser.predictions;
                                                    currentUser.futurePredictions;
                                                  });
                                                });
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                color: kTransparentColor4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    )
                                        : Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(height: 30,),
                                        SizedBox(
                                          height: 50.0,
                                          width: 160.0,
                                          child: Tooltip(
                                            message: 'Accuracy History',
                                            child: SfLinearGauge(
                                              orientation:
                                              LinearGaugeOrientation
                                                  .vertical,
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
                                                        currentUser
                                                            .pastPredictions
                                                            .length -
                                                            10;
                                                i--)
                                                  LinearBarPointer(
                                                    enableAnimation: true,
                                                    value: (100-((currentUser
                                                        .pastPredictions[
                                                    i - 1]
                                                        .errorPercentage
                                                        .abs()) >=
                                                        100.0
                                                        ? 100.0
                                                        : (currentUser
                                                        .pastPredictions[
                                                    i - 1]
                                                        .errorPercentage
                                                        .abs()))),
                                                    color: currentUser
                                                        .pastPredictions[
                                                    i - 1]
                                                        .errorPercentage.abs() <
                                                        10
                                                        ? kGreen
                                                        : currentUser
                                                        .pastPredictions[
                                                    i - 1]
                                                        .errorPercentage.abs() <20?kYellow:kRed,
                                                    edgeStyle: LinearEdgeStyle
                                                        .bothCurve,
                                                    offset: i * 10,
                                                    position:
                                                    LinearElementPosition
                                                        .outside,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Predictions(currentUser, widget.realPriceList);
                              })).then((_) {
                            setState(() {
                              currentUser.predictions;
                              currentUser.futurePredictions;
                            });
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        child: glassCard(
                          context,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Forecasts',
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
                                              text: 'Forecasted Dates\n',
                                              style: kCardSmallTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: getAverageForecastDays()
                                                      .toString(),
                                                  style: kCardTextStyle2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Average Error\n',
                                              style: kCardSmallTextStyle,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: getAverageForecastError().roundToDouble()
                                                      .toString()+'%',
                                                  style: kCardTextStyle2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0,bottom: 10),
                                      child: SizedBox(
                                        height: 110,
                                        width: 110,
                                        child: SfRadialGauge(
                                          axes:[
                                            RadialAxis(
                                                startAngle: 90,
                                                endAngle: 90,
                                                minimum: 0,
                                                maximum: 100,
                                                showLabels: false,
                                                showTicks: false,
                                                axisLineStyle: const AxisLineStyle(
                                                  thickness: 0.15,
                                                  color: kBaseColor1,
                                                  thicknessUnit: GaugeSizeUnit.factor,
                                                ),
                                                pointers:[
                                                  RangePointer(
                                                    color: (getAverageForecastError())<
                                                        10
                                                        ? kGreen
                                                        : (getAverageForecastError())<
                                                        20
                                                        ? kYellow
                                                        : kRed,
                                                    animationType: AnimationType.ease,
                                                    enableAnimation: true,
                                                    cornerStyle: CornerStyle.bothCurve,
                                                    width: 0.15,
                                                    sizeUnit: GaugeSizeUnit.factor,
                                                    value: (100-getAverageForecastError()),
                                                  ),
                                                ],
                                              annotations: <GaugeAnnotation>[
                                                GaugeAnnotation(
                                                  positionFactor: 0.1,
                                                  angle: 90,
                                                  widget: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text: 'Accuracy\n',
                                                      style: kCardSmallTextStyle,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: (100-getAverageForecastError()).roundToDouble()
                                                              .toString()+'%',
                                                          style: kCardTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
                                return Forecasts(widget.realPriceList,widget.mlPredictionPriceList);
                              }));
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        child: glassCard(
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
                              for (int i = 0; (i < selectedCryptocurrencies.length && i<5); i++)
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/cryptocoin_icons/color/' +
                                            selectedCryptocurrencies[i].toLowerCase() +
                                            '.svg',
                                        width: 35.0,
                                        height: 35.0,
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      SizedBox(
                                        width: 80.0,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              selectedCryptocurrencies[i],
                                              style: kCardTextStyle,
                                            ),
                                            Text(
                                              cryptocurrencyNames[selectedCryptocurrencies[i]].toString(),
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
                                                  selectedCryptocurrencies[i] + '-USD',
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
                                                    .closePrice),
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
                                                  double.parse((widget
                                                      .realPriceList[i]
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
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return CurrencyMarket(i, widget.realPriceList);
                                        }));
                                  },
                                ),
                              selectedCryptocurrencies.length>5?
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return Market(widget.realPriceList);
                                          }));
                                    },
                                    child: const Text(
                                      'More Currencies',
                                      style: kLinkStyle,
                                    )),
                              ):
                                  const SizedBox(),
                            ],
                          ),
                        ),
                           onTap:  () {
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context) {
                                   return Market(widget.realPriceList);
                                 }));
                           },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        child: glassCard(
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
                                padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                                child: Column(
                                  children: [
                                    for (var news
                                    in pickRandomItemsAsList(widget.newsList, 5))
                                      InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              const SizedBox(
                                height: 10,
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
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return NewsListDisplay(widget.newsList);
                              }));
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
              ),
              ),

          );

  }
}
