import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:glass/glass.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/database_data.dart';
import 'dashboard_loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(this.currentUser, this.realPriceList, {Key? key}) : super(key: key);
  static const String id = 'dashboard';
  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Prediction> getUserPredictions ({required String currency,bool past=false}){
    List<Prediction> predictions=[];
    List<Prediction> predictionSnap=past?currentUser.pastPredictions:currentUser.predictions;
    if(currency=='all'){
      predictions=predictionSnap;
    }
    else{
      for(var prediction in predictionSnap){
        if(prediction.predictedCurrency==currency+'-USD'){
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  List<RealPrice> getRealPrices ({required String currency, int number=0}){
    List<RealPrice> realPrices=[];
    for(var type in widget.realPriceList){
      if(type.currency==currency){
        realPrices=type.pricesList;
        break;
      }
    }
    if(number!=0 && realPrices.length>number){
      return realPrices.sublist(realPrices.length-number);
    }
    return realPrices;
  }

  bool closePriceCheckBox=true, openPriceCheckBox=false, highPriceCheckBox=false, lowPriceCheckBox=false, ohlcCheckBox=true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: logoAppBar(context),
        ),
        body: LiquidPullToRefresh(
          backgroundColor: kBackgroundColor,
          color: kBaseColor2,
          onRefresh: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, DashboardLoading.id, (route) => false);
          },
          child: ListView(
            children: <Widget>[
              glassCard(context, Column(
                children: <Widget>[
                  const Text(
                    'Predictions',
                    style: kCardTextStyle,
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
                              animationType: AnimationType.ease,
                              enableAnimation: true,
                              animationDuration: kAnimationTime.toDouble(),
                              value: currentUser.accuracy.roundToDouble(),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(text: TextSpan(
                                    text: currentUser.accuracy
                                        .round()
                                        .toString(),
                                    style: kCardNumberStyle,
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: '%',
                                        style: kCardTextStyle,
                                      )
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
              glassCard(context, Column(
                children: <Widget>[
                  const Text(
                    'Errors',
                    style: kCardTextStyle,
                  ),
                  SizedBox(
                    width: 500.0,
                    height: 100.0,
                    child: SfLinearGauge(
                      orientation: LinearGaugeOrientation.vertical,
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      showAxisTrack: false,
                      isMirrored: true,
                      barPointers: [
                        for(int i=currentUser.pastPredictions.length;i>0 && i>currentUser.pastPredictions.length-10;i--)
                          LinearBarPointer(
                            enableAnimation: true,
                            animationDuration: kAnimationTime,
                            value: (currentUser.pastPredictions[i-1].errorPercentage<0?(-currentUser.pastPredictions[i-1].errorPercentage):currentUser.pastPredictions[i-1].errorPercentage)>=100.0?100.0:(currentUser.pastPredictions[i-1].errorPercentage<0?(-currentUser.pastPredictions[i-1].errorPercentage):currentUser.pastPredictions[i-1].errorPercentage),
                            color: currentUser.pastPredictions[i-1].errorPercentage>0?kGreen:kRed,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            offset: i*10,
                            position: LinearElementPosition.outside,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              /*glassCard(context, Column(
                children: [
                  charts.SfCartesianChart(
                      primaryXAxis: charts.DateTimeAxis(),
                      series: <charts.ChartSeries>[
                        charts.LineSeries<Prediction, DateTime>(
                          markerSettings: const charts.MarkerSettings(
                            isVisible: true,
                            color: kBlue,
                            borderWidth: 0.0,
                          ),
                            dataSource: getUserPredictions(currency: 'BTC'),
                            xValueMapper: (Prediction data, _) => data.predictedDateAsDate,
                            yValueMapper: (Prediction data, _) => data.predictedClosePrice,
                        ),
                      ],
                  ),
                ],
              ),
              ),*/
              glassCard(context, Column(
                children: [
                  for(int i=0;i<cryptocurrencies.length;i++)
                    openCloseAnimation(context,
                        closeWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150.0,
                              height: 120.0,
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
                                    dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD',number: 10),
                                    xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                    yValueMapper: (RealPrice data, _) => data.closePrice,
                                    pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30.0,),
                            SizedBox(
                              width: 60.0,
                              child: Text(
                                cryptocurrencies[i],
                                style: kCardTextStyle,
                              ),
                            ),
                          ],
                        ),
                        openWidget: SafeArea(
                            child: glassCard(context, Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 200.0,
                                    child: Text(
                                      cryptocurrencyNames[i]+' '+cryptocurrencies[i],
                                      style: kCardTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 500.0,
                                    child: Column(
                                      children: [
                                        /*CheckboxListTile(
                                          title: const Text('ohlc graphs'),
                                          value: ohlcCheckBox,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              print(value);
                                              ohlcCheckBox = value!;
                                            });
                                          },
                                          secondary: const Icon(Icons.hourglass_empty),
                                        ),*/
                                        Checkbox(
                                            value: ohlcCheckBox,
                                            onChanged: (bool? value){
                                              setState(() {
                                                print(value);
                                                ohlcCheckBox = value!;
                                              });
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: charts.SfCartesianChart(
                                      primaryXAxis: charts.DateTimeAxis(
                                      ),
                                      primaryYAxis: charts.NumericAxis(
                                      ),
                                      plotAreaBorderWidth: 1,
                                      series: <charts.ChartSeries>[
                                        charts.HiloOpenCloseSeries<RealPrice, DateTime>(
                                          isVisible: ohlcCheckBox,
                                            dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                            xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                            lowValueMapper: (RealPrice data, _) => data.lowestPrice,
                                            highValueMapper: (RealPrice data, _) => data.highestPrice,
                                            openValueMapper: (RealPrice data, _) => data.openPrice,
                                            closeValueMapper: (RealPrice data, _) => data.closePrice,
                                        ),
                                        charts.LineSeries<RealPrice, DateTime>(
                                          dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                          xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                          yValueMapper: (RealPrice data, _) => data.closePrice,
                                          //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ),
                    ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: LiquidCircularProgressIndicator(
                            value: currentUser.accuracy / 100.roundToDouble(),
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.green),
                            backgroundColor: Colors.white,
                            borderColor: Colors.red,
                            borderWidth: 0.0,
                            direction: Axis.vertical,
                            center: CircleAvatar(
                              radius: 25.0,
                              child: Image.asset(
                                  'assets/images/CryptoPal-logo-black.png'),
                            ),
                          ),
                        ),*/

/*SizedBox(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Horizon',
                  ),
                  child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('AWESOME'),
                        RotateAnimatedText('OPTIMISTIC'),
                        RotateAnimatedText('DIFFERENT'),
                      ]

                ),
              ),
              ),*/