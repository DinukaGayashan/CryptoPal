import 'package:cryptopal/screens/add_prediction.dart';
import 'package:cryptopal/screens/show_graphs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:glass/glass.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
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

  final _firestore=FirebaseFirestore.instance;
  late int selectedCrypto=0;
  late double predictionPrice;
  late DateTime predictionDate=DateTime.now().add(const Duration(days:1));

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        /*appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: logoAppBar(context),
        ),*/
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
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
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              openCloseAnimation(
                  context,
                  closeWidget: glassCard(context, Column(
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
                  openWidget: SafeArea(
                child: glassCard(context, ListView(
                children: [
                  FloatingActionButton.extended(
                    label: const Text('Add Prediction'),
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return AddPrediction(currentUser);
                      }));
                      /*Navigator.push(context, PageTransition(
                        child: AddPrediction(currentUser),
                        type: PageTransitionType.fade,
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 100),
                      ),
                      );*/
                    },
                  ),
                ],
              ),
              ),
        ),
              ),
              openCloseAnimation(context,
                  closeWidget: glassCard(context, Column(
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
                  openWidget: SafeArea(
                    child: glassCard(context, ListView(
                    children: [

                    ],
                    ),
                    ),
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
                        closeWidget: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 10.0,),
                              SvgPicture.asset(
                                'assets/images/cryptocoin_icons/color/'+cryptocurrencies[i].toLowerCase()+'.svg',
                                  width: 35.0,
                                height: 35.0,
                              ),
                              const SizedBox(width: 15.0,),
                              SizedBox(
                                width: 80.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              const SizedBox(width: 5.0,),
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
                                      dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD',number: 20),
                                      xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                      yValueMapper: (RealPrice data, _) => data.closePrice,
                                      color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                      //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0,),
                              Icon(
                                widget.realPriceList[i].priceIncreasePercentage>0?Icons.arrow_upward:Icons.arrow_downward,
                                color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                size: 15,
                              ),
                              SizedBox(
                                width: 60.0,
                                child: Text(
                                  double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2)).toString()+'%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Bierstadt',
                                    color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        openWidget: SafeArea(
                            child: glassCard(context, SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    cryptocurrencyNames[i],
                                    style: kSubSubjectStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 15.0,),
                                  SvgPicture.asset(
                                    'assets/images/cryptocoin_icons/color/'+cryptocurrencies[i].toLowerCase()+'.svg',
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                  const SizedBox(height: 25.0,),
                                  Center(
                                    child: RichText(text: TextSpan(
                                      text: "\$ "+widget.realPriceList[i].pricesList.last.closePrice.toString()+' ',
                                      style: kCardNumberStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: cryptocurrencies[i],
                                          style: kCardTextStyle,
                                        ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2))<0?(-double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2))):double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2))).toString()+'%',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Bierstadt',
                                          color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                        ),
                                      ),
                                      Icon(
                                        widget.realPriceList[i].priceIncreasePercentage>0?Icons.arrow_upward:Icons.arrow_downward,
                                        color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height-370,
                                    child: charts.SfCartesianChart(
                                      title: charts.ChartTitle(
                                        text: 'Close Price',
                                        textStyle: kCardTextStyle,
                                      ),
                                      zoomPanBehavior: charts.ZoomPanBehavior(
                                        enablePinching: true,
                                        enablePanning: true,
                                        enableMouseWheelZooming: true,
                                        zoomMode: charts.ZoomMode.xy,
                                      ),
                                      primaryXAxis: charts.DateTimeAxis(),
                                      primaryYAxis: charts.NumericAxis(),
                                      plotAreaBorderWidth: 1,
                                      enableAxisAnimation: true,
                                      crosshairBehavior: charts.CrosshairBehavior(
                                        enable: true,
                                      ),
                                      tooltipBehavior: charts.TooltipBehavior(
                                        enable: true,
                                      ),
                                      series: <charts.ChartSeries>[
                                        charts.LineSeries<RealPrice, DateTime>(
                                          animationDuration: kAnimationTime.toDouble(),
                                          color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                          name: cryptocurrencies[i]+' Close Price',
                                          dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                          xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                          yValueMapper: (RealPrice data, _) => data.closePrice,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //const SizedBox(height: 10.0,),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: kInstructionStyle,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return ShowGraphs(widget.realPriceList, i);
                                      }));
                                    },
                                    child: const Text(
                                      'More Graphs',
                                      style: kLinkStyle,
                                    ),
                                  ),
                                ],
                              ),
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