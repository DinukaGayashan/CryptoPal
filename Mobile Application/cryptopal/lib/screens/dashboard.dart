import 'package:cryptopal/screens/add_prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:crypto_font_icons/crypto_font_icons.dart';

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
                  openWidget: SafeArea(
                child: glassCard(context, ListView(
                children: [
                  openCloseAnimation(context,
                    closeWidget: Column(
                      children:[
                        const Icon(
                        Icons.add,
                      ),
                        FloatingActionButton.extended(
                          label: const Text('Add Prediction'),
                          icon: const Icon(Icons.add),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return AddPrediction(currentUser);
                              }));
                            },
                        ),
                      ],
                    ),
                    openWidget: SafeArea(
                      child: glassCard(context, ListView(
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Center(
                            child: Text(
                              'Add Prediction',
                              style: kSubSubjectStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            child: CupertinoButton(
                              onPressed: () {
                                showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) => Container(
                                      height: 300,
                                      padding: const EdgeInsets.only(top: 10.0),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                      ),
                                      color: kTransparentColor,
                                      child: SafeArea(
                                        top: false,
                                        child: CupertinoPicker(
                                          onSelectedItemChanged: (int value) {
                                            setState(() {
                                              selectedCrypto=value;
                                            });
                                          },
                                          itemExtent: 32.0,
                                          children: List<Widget>.generate(cryptocurrencyNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                cryptocurrencyNames[index]+' ('+cryptocurrencies[index]+')',
                                                style: kButtonTextStyle,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ));
                              },
                              child: Text(
                                cryptocurrencyNames[selectedCrypto],
                                style: kSubjectStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 100,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime.now().add(const Duration(days:1)),
                              minimumDate: DateTime.now(),
                              onDateTimeChanged: (DateTime value) {
                                predictionDate=value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Closing Price',
                                style: kInstructionStyle2,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              SizedBox(
                                width: 160.0,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  style: kDetailsStyle,
                                  cursorHeight: 25,
                                  cursorColor: kAccentColor3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kAccentColor3,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kAccentColor3,
                                      ),
                                    ),
                                    labelText: 'Enter your prediction',
                                    labelStyle: kHintStyle,
                                    floatingLabelStyle: kHintStyle,
                                  ),
                                  onChanged: (value){
                                    predictionPrice=double.parse(value);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'USD',
                                style: kInstructionStyle2,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          MaterialButton(
                            color: kAccentColor3,
                            height:40.0,
                            minWidth: double.infinity,
                            onPressed: () async {
                              try{
                                await _firestore.collection('users').doc(currentUser.user?.uid)
                                    .collection('predictions')
                                    .doc(predictionDate.toString().split(' ')[0]+' '+cryptocurrencies[selectedCrypto]+'-USD')
                                    .set(
                                    {
                                      'predictedDate':predictionDate.toString().split(' ')[0],
                                      'predictedCurrency':cryptocurrencies[selectedCrypto]+'-USD',
                                      'predictedClosePrice': predictionPrice.toDouble(),
                                    }
                                );
                              }
                              catch(e){
                                print(e);
                              }
                            },
                            child: const Text(
                              'Add Prediction',
                              style: kButtonTextStyle,
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
                        closeWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(width: 10.0,),
                            Icon(
                              getIconByName(cryptocurrencies[i]),
                              //color: kAccentColor1,
                              size: 30.0,
                            ),
                            const SizedBox(width: 10.0,),
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
                            const SizedBox(width: 10.0,),
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
                            SizedBox(
                              width: 45.0,
                              child: Text(
                                double.parse((widget.realPriceList[i].priceIncreasePercentage).toStringAsFixed(2)).toString()+'%',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Bierstadt',
                                  color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                                ),
                              ),
                            ),
                            Icon(
                              widget.realPriceList[i].priceIncreasePercentage>0?Icons.arrow_upward:Icons.arrow_downward,
                              color: widget.realPriceList[i].priceIncreasePercentage>0?kGreen:kRed,
                              size: 15,
                            ),
                            const SizedBox(width: 10.0,),
                          ],
                        ),
                        openWidget: SafeArea(
                            child: glassCard(context, ListView(
                              children: [
                                Text(
                                  cryptocurrencyNames[i],
                                  style: kCardTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15.0,),
                                Icon(
                                  getIconByName(cryptocurrencies[i]),
                                  //CryptoCoinIcons.getCryptoIcon(cryptocurrencies[i]),
                                  size: 50.0,
                                  //color: kTransparentColor,
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
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30.0,
                                  //child:
                                      /*CheckboxListTile(
                                        title: const Text('OHLC graph'),
                                        value: ohlcCheckBox,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            ohlcCheckBox = value!;
                                          });
                                        },
                                        secondary: const Icon(Icons.graphic_eq),
                                      ),
                                      CheckboxListTile(
                                        title: const Text('Close Price graph'),
                                        value: closePriceCheckBox,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            closePriceCheckBox = value!;
                                          });
                                        },
                                        secondary: const Icon(Icons.graphic_eq),
                                      ),
                                      CheckboxListTile(
                                        title: const Text('Open Price graph'),
                                        value: openPriceCheckBox,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            print(value);
                                            openPriceCheckBox = value!;
                                          });
                                        },
                                      ),*/
                                      //SizedBox(height: 30.0,),
                                      /*Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                              value: ohlcCheckBox,
                                              onChanged: (bool? value){
                                                setState(() {
                                                  ohlcCheckBox = value!;
                                                });
                                              }
                                          ),
                                          const Text(
                                            'OHLC',
                                            style: kCardSmallTextStyle,
                                          ),
                                          const SizedBox(width: 30.0,),
                                          Checkbox(
                                              value: closePriceCheckBox,
                                              onChanged: (bool? value){
                                                setState(() {
                                                  closePriceCheckBox = value!;
                                                });
                                              }
                                          ),
                                          const Text(
                                            'Close',
                                            style: kCardSmallTextStyle,
                                          ),
                                          const SizedBox(width: 30.0,),
                                          Checkbox(
                                              value: openPriceCheckBox,
                                              onChanged: (bool? value){
                                                setState(() {
                                                  openPriceCheckBox = value!;
                                                });
                                              }
                                          ),
                                          const Text(
                                            'Open',
                                            style: kCardSmallTextStyle,
                                          ),
                                        ],
                                      ),*/
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 350.0,
                                  child: charts.SfCartesianChart(
                                    title: charts.ChartTitle(
                                      text: 'Close Price Series',
                                      textStyle: kCardTextStyle,
                                    ),
                                    zoomPanBehavior: charts.ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      enableMouseWheelZooming: true,
                                      enableDoubleTapZooming: true,
                                      zoomMode: charts.ZoomMode.xy,
                                    ),
                                    primaryXAxis: charts.DateTimeAxis(
                                    ),
                                    primaryYAxis: charts.NumericAxis(
                                    ),
                                    plotAreaBorderWidth: 1,
                                    crosshairBehavior: charts.CrosshairBehavior(
                                      enable: true,
                                    ),
                                    tooltipBehavior: charts.TooltipBehavior(
                                      enable: true,
                                    ),
                                    series: <charts.ChartSeries>[
                                      charts.LineSeries<RealPrice, DateTime>(
                                        name: cryptocurrencies[i]+' Close Price',
                                        dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                        xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                        yValueMapper: (RealPrice data, _) => data.closePrice,
                                        //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                SizedBox(
                                  width: double.infinity,
                                  height: 350.0,
                                  child: charts.SfCartesianChart(
                                    title: charts.ChartTitle(
                                      text: 'Candle Series',
                                      textStyle: kCardTextStyle,
                                    ),
                                    zoomPanBehavior: charts.ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      enableMouseWheelZooming: true,
                                      enableDoubleTapZooming: true,
                                      zoomMode: charts.ZoomMode.xy,
                                    ),
                                    primaryXAxis: charts.DateTimeAxis(
                                    ),
                                    primaryYAxis: charts.NumericAxis(
                                    ),
                                    plotAreaBorderWidth: 1,
                                    tooltipBehavior: charts.TooltipBehavior(
                                      enable: true,
                                    ),
                                    series: <charts.ChartSeries>[
                                      charts.CandleSeries<RealPrice, DateTime>(
                                        name: cryptocurrencies[i]+' Prices',
                                        dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                        xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                        lowValueMapper: (RealPrice data, _) => data.lowestPrice,
                                        highValueMapper: (RealPrice data, _) => data.highestPrice,
                                        openValueMapper: (RealPrice data, _) => data.openPrice,
                                        closeValueMapper: (RealPrice data, _) => data.closePrice,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                SizedBox(
                                  width: double.infinity,
                                  height: 350.0,
                                  child: charts.SfCartesianChart(
                                    title: charts.ChartTitle(
                                      text: 'Hilo Open Close Series',
                                      textStyle: kCardTextStyle,
                                    ),
                                    zoomPanBehavior: charts.ZoomPanBehavior(
                                      enablePinching: true,
                                      enablePanning: true,
                                      enableMouseWheelZooming: true,
                                      enableDoubleTapZooming: true,
                                      zoomMode: charts.ZoomMode.xy,
                                    ),
                                    primaryXAxis: charts.DateTimeAxis(
                                    ),
                                    primaryYAxis: charts.NumericAxis(
                                    ),
                                    plotAreaBorderWidth: 1,
                                    tooltipBehavior: charts.TooltipBehavior(
                                      enable: true,
                                    ),
                                    series: <charts.ChartSeries>[
                                      charts.HiloOpenCloseSeries<RealPrice, DateTime>(
                                        name: cryptocurrencies[i]+' Prices',
                                        dataSource: getRealPrices(currency: cryptocurrencies[i]+'-USD'),
                                        xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                                        lowValueMapper: (RealPrice data, _) => data.lowestPrice,
                                        highValueMapper: (RealPrice data, _) => data.highestPrice,
                                        openValueMapper: (RealPrice data, _) => data.openPrice,
                                        closeValueMapper: (RealPrice data, _) => data.closePrice,
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