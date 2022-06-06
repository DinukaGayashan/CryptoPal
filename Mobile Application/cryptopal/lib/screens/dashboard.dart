import 'dart:math';
import 'package:cryptopal/screens/predictions/add_prediction.dart';
import 'package:cryptopal/screens/predictions/currency_predictions.dart';
import 'package:cryptopal/screens/market/show_market_graphs.dart';
import 'package:flutter/gestures.dart';
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
import 'package:cryptopal/utility/news_data.dart';
import 'dashboard_loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard(this.currentUser, this.realPriceList, this.newsList, {Key? key}) : super(key: key);
  static const String id = 'dashboard';
  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;
  final List<News> newsList;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  //final _firestore=FirebaseFirestore.instance;
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

  List<Prediction> getUserFuturePredictions ({required String currency}){
    List<Prediction> predictions=[];
    for(var p in currentUser.futurePredictions){
      if(p.predictedCurrency==currency+'-USD'){
        predictions.add(p);
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

  RealPrice? getRealPrice({required String currency, required String date}){
    final List<RealPrice> priceList=getRealPrices(currency: currency+'-USD');
    RealPrice x=RealPrice(date, 0, 0, 0, 0);
    for(var i in priceList){
      if(i.date==date){
        x=i;
      }
    }
    return x;
  }

  String getBestCryptocurrency(){
    double minError=double.infinity;
    int index=0;
    for(int i=0;i<cryptocurrencies.length;i++){
      if(currentUser.errorVarianceOnCurrencies.values.elementAt(i)<minError){
        minError=currentUser.errorVarianceOnCurrencies.values.elementAt(i);
        index=i;
      }
    }
    return minError.isNaN?'-':cryptocurrencyNames[index];
  }

  List<ValueOnCurrency> getValuesOnCurrency({required String currency, required String type}){
    List<ValueOnCurrency> currencyValues=[];
    Iterable<String> dates=currentUser.history.keys;
    if(type=='error'){
      for(var d in dates){
        currencyValues.add(ValueOnCurrency(d,currentUser.history[d]?.errorsOnCurrencies[currency]));
      }
    }
    else {
      for(var d in dates){
        currencyValues.add(ValueOnCurrency(d,currentUser.history[d]?.errorVarianceOnCurrencies[currency]));
      }
    }
    return currencyValues;
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
          color: kAccentColor1,
          onRefresh: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, DashboardLoading.id, (route) => false);
          },
          child: ListView(
          //physics: const AlwaysScrollableScrollPhysics(),
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
                      child: DefaultTextStyle(
                        child: Text(
                          'CryptoPal',
                        ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:EdgeInsets.all(10),
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
                              height:150.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'Average Error\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.error.roundToDouble().toString(),
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
                                          text: currentUser.standardDeviation.roundToDouble().toString(),
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
                                      //animationDuration: kAnimationTime.toDouble(),
                                      value: currentUser.accuracy>0?currentUser.accuracy.roundToDouble():0,
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
                                            text: currentUser.accuracy>0?currentUser.accuracy
                                                .round()
                                                .toString():'NaN',
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
                  openWidget: SafeArea(
                child: glassCard(context, ListView(
                children: [
                  topBar(context, 'Statistics',),
                  const SizedBox(height: 30.0,),



                  const Center(
                    child: Text(
                      'Cryptocurrency Prediction Accuracy',
                      style: kCardSmallTextStyle,
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  SfLinearGauge(
                    minimum: 0,
                    maximum: 100,
                    //showLabels: false,
                    //showTicks: false,
                    showAxisTrack: false,
                    isMirrored: true,
                    barPointers: [
                      for(int i=0;i<cryptocurrencies.length;i++)
                        LinearBarPointer(
                          thickness: 25.0,
                          enableAnimation: true,
                          //animationDuration: kAnimationTime,
                          value: (currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble(),
                          color: ((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs())>50?kGreen:kRed,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          offset: i*30+35,
                          position: LinearElementPosition.outside,
                          child: Center(
                            child: Text(
                              cryptocurrencies[i]+' '+((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble()).toString()+'%',
                              style: kCardSmallTextStyle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              ),
        ),
              ),
              openCloseAnimation(context,
                  closeWidget: glassCard(context, Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding:EdgeInsets.all(10),
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
                              height:100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: 'Total Predictions\n',
                                      style: kCardSmallTextStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.predictions.length.toString(),
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
                                          text: currentUser.pastPredictions.length.toString(),
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
                              children:<Widget>[
                                SizedBox(
                                  height: 70.0,
                                  width: 150.0,
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
                                          //animationDuration: kAnimationTime,
                                          value: (currentUser.pastPredictions[i-1].errorPercentage.abs())>=100.0?100.0:(currentUser.pastPredictions[i-1].errorPercentage.abs()),
                                          color: currentUser.pastPredictions[i-1].errorPercentage>0?kGreen:kRed,
                                          edgeStyle: LinearEdgeStyle.bothCurve,
                                          offset: i*10,
                                          position: LinearElementPosition.outside,
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      'Past Errors',
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
                  openWidget: SafeArea(
                    child: glassCard(context, ListView(
                    children: <Widget>[
                      topBar(context, 'Predictions'),
                      const SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Total Predictions\n',
                              style: kCardTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: currentUser.predictions.length.toString(),
                                  style: kCardTextStyle3,
                                ),
                              ],
                            ),
                          ),
                          Tooltip(
                            message: 'Add Prediction',
                            child: FloatingActionButton(
                              backgroundColor: kAccentColor1,
                              child: const Icon(Icons.add),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return AddPrediction(currentUser);
                                }));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Past Predictions\n',
                              style: kCardSmallTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: currentUser.pastPredictions.length.toString(),
                                  style: kCardTextStyle2,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Future Predictions\n',
                              style: kCardSmallTextStyle,
                              children: <TextSpan>[
                                TextSpan(
                                  text: (currentUser.futurePredictions.length).toString(),
                                  style: kCardTextStyle2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0,),
                      for(int i=0;i<cryptocurrencies.length;i++)
                        GestureDetector(
                      child: glassCard(context,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/images/cryptocoin_icons/color/'+cryptocurrencies[i].toLowerCase()+'.svg',
                                width: 40.0,
                                height: 40.0,
                              ),
                              const SizedBox(height: 10,),
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
                          const SizedBox(width: 20.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Predictions\n',
                                  style: kCardSmallTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: getUserPredictions(currency: cryptocurrencies[i]).length.toString(),
                                      style: kCardTextStyle2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              RichText(
                                text: TextSpan(
                                  text: 'Accuracy\n',
                                  style: kCardSmallTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble()).toString(),
                                      style: kCardTextStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Past Predictions\n',
                                  style: kCardSmallTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: getUserPredictions(currency: cryptocurrencies[i], past: true).length.toString(),
                                      style: kCardTextStyle2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              RichText(
                                text: TextSpan(
                                  text: 'Error Deviation\n',
                                  style: kCardSmallTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: sqrt(currentUser.errorVarianceOnCurrencies[cryptocurrencies[i]]??0).roundToDouble().toString(),
                                      style: kCardTextStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return CurrencyPredictions(currentUser, i, widget.realPriceList,);
                  }));
                },
                  ),



                        /*openCloseAnimation(context,
                          closeWidget:
                          openWidget: SafeArea(
                            child: glassCard(context,
                                ListView(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20.0,
                                          child: IconButton(
                                            icon: const Icon(Icons.arrow_back_ios),
                                            color: kBaseColor2,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Text(
                                          cryptocurrencyNames[i]+' Predictions',
                                          style: kSubSubjectStyle,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0,),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Prediction Accuracy',
                                          style: kCardSmallTextStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' '+((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs()).roundToDouble().toString()+'%',
                                              style: kCardTextStyle2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0,),
                                    SfLinearGauge(
                                      minimum: 0,
                                      maximum: 100,
                                      showTicks: false,
                                      showAxisTrack: false,
                                      isMirrored: true,
                                      barPointers: [
                                          LinearBarPointer(
                                            thickness: 25.0,
                                            enableAnimation: true,
                                            //animationDuration: kAnimationTime,
                                            value: (currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs().roundToDouble(),
                                            color: ((currentUser.errorsOnCurrencies[cryptocurrencies[i]]!).abs()>100?0:(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!-(currentUser.errorsOnCurrencies[cryptocurrencies[i]]!>0?100:-100)).abs())>50?kGreen:kRed,
                                            edgeStyle: LinearEdgeStyle.bothCurve,
                                            offset: 20,
                                            position: LinearElementPosition.outside,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        openCloseAnimation(context,
                                            closeWidget: Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: kTransparentColor,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'Past Predictions\n',
                                                      style: kCardSmallTextStyle,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: getUserPredictions(currency: cryptocurrencies[i],past: true).length.toString(),
                                                          style: kCardTextStyle2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            openWidget: SafeArea(
                                              child: glassCard(context,
                                                ListView(
                                                  children: <Widget>[
                                                Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20.0,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.arrow_back_ios),
                                                        color: kBaseColor2,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      cryptocurrencyNames[i]+' Past Predictions',
                                                      style: kSubSubjectStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                  ],
                                                ),
                                                    const SizedBox(height: 20.0,),
                                                    for(var x in getUserPredictions(currency: cryptocurrencies[i],past: true).reversed)
                                                      openCloseAnimation(context,
                                                        closeWidget: glassCard(context, Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children:<Widget>[
                                                                  SizedBox(
                                                                    height:45.0,
                                                                    child: Text(
                                                                      x.predictedDate,
                                                                      style: kCardTextStyle,
                                                                    ),
                                                                  ),
                                                                  //const SizedBox(height: 15.0,),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: 'Error Percentage\n',
                                                                      style: kCardSmallTextStyle,
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: x.errorPercentage.roundToDouble().toString(),
                                                                          style: kCardTextStyle2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 10.0,),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: 'Error\n',
                                                                      style: kCardSmallTextStyle,
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: x.errorValue.roundToDouble().toString(),
                                                                          style: kCardTextStyle2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children:<Widget>[
                                                                  const SizedBox(height: 45.0,),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: 'Predicted Price\n',
                                                                      style: kCardSmallTextStyle,
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: x.predictedClosePrice.toString(),
                                                                          style: kCardTextStyle2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 10.0,),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text: 'Actual Price\n',
                                                                      style: kCardSmallTextStyle,
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: getRealPrice(currency: cryptocurrencies[i], date: x.predictedDate)?.closePrice.toString(),
                                                                          style: kCardTextStyle2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ),
                                                          openWidget: SafeArea(
                                                            child: SizedBox(
                                                              width: MediaQuery.of(context).size.width,
                                                              height: MediaQuery.of(context).size.height,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 20.0,
                                                                          child: IconButton(
                                                                            icon: const Icon(Icons.arrow_back_ios),
                                                                            color: kBaseColor2,
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          cryptocurrencyNames[i]+' Past Prediction',
                                                                          style: kSubSubjectStyle,
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 20.0,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: MediaQuery.of(context).size.height-100,
                                                                      child: charts.SfCartesianChart(
                                                                        title: charts.ChartTitle(
                                                                          text: 'Close Price',
                                                                          textStyle: kCardSmallTextStyle,
                                                                        ),
                                                                        legend: charts.Legend(
                                                                          isVisible: true,
                                                                          overflowMode: charts.LegendItemOverflowMode.wrap,
                                                                          position: charts.LegendPosition.bottom,
                                                                        ),
                                                                        zoomPanBehavior: charts.ZoomPanBehavior(
                                                                          enablePinching: true,
                                                                          enablePanning: true,
                                                                          enableMouseWheelZooming: true,
                                                                          zoomMode: charts.ZoomMode.xy,
                                                                        ),
                                                                        primaryXAxis: charts.DateTimeAxis(
                                                                          visibleMinimum: kMinDayInGraph,
                                                                        ),
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
                                                                            //color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                                                            name: cryptocurrencies[i]+' Close Price',
                                                                            dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                                                            xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                                                            yValueMapper: (RealPrice data, _) => data.closePrice,
                                                                          ),
                                                                          charts.LineSeries<Prediction, DateTime>(
                                                                            name: cryptocurrencies[i]+' Prediction',
                                                                            dataSource: x.toList(x),
                                                                            xValueMapper: (Prediction data, _) => data.predictedDateAsDate,
                                                                            yValueMapper: (Prediction data, _) => data.predictedClosePrice,
                                                                            markerSettings: const charts.MarkerSettings(
                                                                              isVisible: true,
                                                                            ),
                                                                          ),
                                                                        ],
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
                                            ),
                                        ),
                                        openCloseAnimation(context,
                                          closeWidget: Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: kTransparentColor,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: 'Future Predictions\n',
                                                    style: kCardSmallTextStyle,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: (getUserPredictions(currency: cryptocurrencies[i]).length-getUserPredictions(currency: cryptocurrencies[i],past: true).length).toString(),
                                                        style: kCardTextStyle2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          openWidget: SafeArea(
                                            child: glassCard(context,
                                              ListView(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 20.0,
                                                        child: IconButton(
                                                          icon: const Icon(Icons.arrow_back_ios),
                                                          color: kBaseColor2,
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        cryptocurrencyNames[i]+' Future Predictions',
                                                        style: kSubSubjectStyle,
                                                      ),
                                                      const SizedBox(
                                                        width: 20.0,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20.0,),
                                                  for(var x in getUserFuturePredictions(currency: cryptocurrencies[i]))
                                                    glassCard(context,
                                                        const Text('data'),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0,),
                                    openCloseAnimation(
                                      context,
                                      closeWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const [
                                          Tooltip(
                                            message: 'Full Screen View',
                                            child: Icon(
                                              Icons.fullscreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      openWidget: SafeArea(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 20.0,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.arrow_back_ios),
                                                        color: kBaseColor2,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      cryptocurrencyNames[i]+' Predictions',
                                                      style: kSubSubjectStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height-100,
                                                  child: charts.SfCartesianChart(
                                                    title: charts.ChartTitle(
                                                      text: 'Close Price',
                                                      textStyle: kCardSmallTextStyle,
                                                    ),
                                                    legend: charts.Legend(
                                                      isVisible: true,
                                                      overflowMode: charts.LegendItemOverflowMode.wrap,
                                                      position: charts.LegendPosition.bottom,
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
                                                        //color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                                        name: cryptocurrencies[i]+' Close Price',
                                                        dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                                        xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                                        yValueMapper: (RealPrice data, _) => data.closePrice,
                                                      ),
                                                      charts.LineSeries<Prediction, DateTime>(
                                                        name: cryptocurrencies[i]+' Prediction',
                                                        dataSource: getUserPredictions(currency: cryptocurrencies[i]),
                                                        xValueMapper: (Prediction data, _) => data.predictedDateAsDate,
                                                        yValueMapper: (Prediction data, _) => data.predictedClosePrice,
                                                        markerSettings: const charts.MarkerSettings(
                                                          isVisible: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: charts.SfCartesianChart(
                                        title: charts.ChartTitle(
                                          text: 'Close Price',
                                          textStyle: kCardSmallTextStyle,
                                        ),
                                        legend: charts.Legend(
                                          isVisible: true,
                                          overflowMode: charts.LegendItemOverflowMode.wrap,
                                          position: charts.LegendPosition.bottom,
                                        ),
                                        zoomPanBehavior: charts.ZoomPanBehavior(
                                          enablePinching: true,
                                          enablePanning: true,
                                          enableMouseWheelZooming: true,
                                          zoomMode: charts.ZoomMode.xy,
                                        ),
                                        primaryXAxis: charts.DateTimeAxis(
                                          visibleMinimum: kMinDayInGraph,
                                        ),
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
                                            //color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                            name: cryptocurrencies[i]+' Close Price',
                                            dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                            xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                            yValueMapper: (RealPrice data, _) => data.closePrice,
                                          ),
                                          charts.LineSeries<Prediction, DateTime>(
                                            //color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                            name: cryptocurrencies[i]+' Prediction',
                                            dataSource: getUserPredictions(currency: cryptocurrencies[i]),
                                            xValueMapper: (Prediction data, _) => data.predictedDateAsDate,
                                            yValueMapper: (Prediction data, _) => data.predictedClosePrice,
                                            markerSettings: const charts.MarkerSettings(
                                              isVisible: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20.0,),
                                    openCloseAnimation(
                                      context,
                                      closeWidget: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: const [
                                          Tooltip(
                                            message: 'Full Screen View',
                                            child: Icon(
                                              Icons.fullscreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      openWidget: SafeArea(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 20.0,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.arrow_back_ios),
                                                        color: kBaseColor2,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      cryptocurrencyNames[i]+' Predictions',
                                                      style: kSubSubjectStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 20.0,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: MediaQuery.of(context).size.height-100,
                                                  child: charts.SfCartesianChart(
                                                    title: charts.ChartTitle(
                                                      text: 'Past Prediction Errors',
                                                      textStyle: kCardSmallTextStyle,
                                                    ),
                                                    legend: charts.Legend(
                                                      isVisible: true,
                                                      overflowMode: charts.LegendItemOverflowMode.wrap,
                                                      position: charts.LegendPosition.bottom,
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
                                                      charts.LineSeries<ValueOnCurrency, DateTime>(
                                                        name: cryptocurrencies[i]+' Prediction Error',
                                                        dataSource: getValuesOnCurrency(currency: cryptocurrencies[i], type: 'error'),
                                                        xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                                                        yValueMapper: (ValueOnCurrency data, _) => data.value.toDouble(),
                                                        markerSettings: const charts.MarkerSettings(
                                                          isVisible: true,
                                                        ),
                                                      ),
                                                      charts.LineSeries<ValueOnCurrency, DateTime>(
                                                        name: cryptocurrencies[i]+' Prediction Error Deviation',
                                                        dataSource: getValuesOnCurrency(currency: cryptocurrencies[i], type: 'variance'),
                                                        xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                                                        yValueMapper: (ValueOnCurrency data, _) => sqrt(data.value).toDouble(),
                                                        markerSettings: const charts.MarkerSettings(
                                                          isVisible: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: charts.SfCartesianChart(
                                        title: charts.ChartTitle(
                                          text: 'Past Prediction Errors',
                                          textStyle: kCardSmallTextStyle,
                                        ),
                                        legend: charts.Legend(
                                          isVisible: true,
                                          overflowMode: charts.LegendItemOverflowMode.wrap,
                                          position: charts.LegendPosition.bottom,
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
                                          charts.LineSeries<ValueOnCurrency, DateTime>(
                                            name: cryptocurrencies[i]+' Prediction Error',
                                            dataSource: getValuesOnCurrency(currency: cryptocurrencies[i], type: 'error'),
                                            xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                                            yValueMapper: (ValueOnCurrency data, _) => data.value.toDouble(),
                                            markerSettings: const charts.MarkerSettings(
                                              isVisible: true,
                                            ),
                                          ),
                                          charts.LineSeries<ValueOnCurrency, DateTime>(
                                            name: cryptocurrencies[i]+' Prediction Error Deviation',
                                            dataSource: getValuesOnCurrency(currency: cryptocurrencies[i], type: 'variance'),
                                            xValueMapper: (ValueOnCurrency data, _) => DateTime.parse(data.date),
                                            yValueMapper: (ValueOnCurrency data, _) => sqrt(data.value.toDouble()),
                                            markerSettings: const charts.MarkerSettings(
                                              isVisible: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                        ),*/
                      const SizedBox(height: 20.0,),
                      MaterialButton(
                        color: kAccentColor1,
                        height: 45.0,
                        minWidth: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.add,
                              color: kBaseColor1,
                            ),
                            SizedBox(width: 10.0,),
                            Text(
                              'Add Prediction',
                              style: kButtonTextStyle,
                            ),
                          ],
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AddPrediction(currentUser);
                          }));
                        },
                      ),
                      const SizedBox(height: 10.0,),
                    ],
                    ),
                    ),
                  ),
              ),
              glassCard(context, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding:EdgeInsets.all(10),
                    child: Text(
                    'Market',
                    style: kCardTitleStyle,
                ),
                  ),
                  for(int i=0;i<cryptocurrencies.length;i++)
                    openCloseAnimation(context,
                        closeWidget: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
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
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 20.0,
                                        child: IconButton(
                                          icon: const Icon(Icons.arrow_back_ios),
                                          color: kBaseColor2,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Text(
                                        cryptocurrencyNames[i],
                                        style: kSubSubjectStyle,
                                      ),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0,),
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
                                    children: <Widget>[
                                      Text(
                                        (double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2)).abs()).toString()+'%',
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
                                    height: 20.0,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height-380,
                                    child: charts.SfCartesianChart(
                                      title: charts.ChartTitle(
                                        text: 'Close Price',
                                        textStyle: kCardSmallTextStyle,
                                      ),
                                      zoomPanBehavior: charts.ZoomPanBehavior(
                                        enablePinching: true,
                                        enablePanning: true,
                                        enableMouseWheelZooming: true,
                                        zoomMode: charts.ZoomMode.xy,
                                      ),
                                      primaryXAxis: charts.DateTimeAxis(
                                        visibleMinimum: kMinDayInGraph,
                                      ),
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
                                  OutlinedButton(
                                      child: const Text(
                                        'More Graphs',
                                        style: kLinkStyle,
                                      ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(width: 1, color: kAccentColor3,),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return ShowMarketGraphs(widget.realPriceList, i);
                                      }));
                                    },
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