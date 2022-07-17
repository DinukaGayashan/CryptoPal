import 'dart:math';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:cryptopal/utility/forecast_price_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:equations/equations.dart';
import 'currency_forecast_graph.dart';

class CurrencyForecasts extends StatefulWidget {
  const CurrencyForecasts(this.realPriceList, this.forecastPriceList, this.currencyIndex,{Key? key}) : super(key: key);

  final List<RealPricesOfACurrency> realPriceList;
  final List<ForecastPricesOfACurrency> forecastPriceList;
  final int currencyIndex;

  @override
  State<CurrencyForecasts> createState() => _CurrencyForecastsState();
}

class _CurrencyForecastsState extends State<CurrencyForecasts> {

  late List<String> dates=getForecastDates();
  late String selectedDate = dates.first;
  late double closePrice=widget.forecastPriceList[widget.currencyIndex].pricesList.where((element) => element.date==selectedDate).first.closePrice;
  late double rsme=widget.forecastPriceList[widget.currencyIndex].errorValue;
  late SfRangeValues priceRange=SfRangeValues(closePrice-3*rsme, closePrice+3*rsme);
  late SfRangeValues selectedRange=SfRangeValues(closePrice-2*rsme, closePrice+2*rsme);

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

  List<ForecastPrice> getForecastPrices({required String currency, int number = 0}) {
    List<ForecastPrice> forecastPrices = [];
    for (var type in widget.forecastPriceList) {
      if (type.currency == currency) {
        forecastPrices = type.pricesList;
        break;
      }
    }
    if (number != 0 && forecastPrices.length > number) {
      return forecastPrices.sublist(0,forecastPrices.length - number);
    }
    return forecastPrices;
  }

  List<String> getForecastDates(){
    List<String> dates=[];
    for(var f in widget.forecastPriceList[widget.currencyIndex].pricesList){
      dates.add(f.date);
    }
    return dates;
  }

  double getProbabilityValue(SfRangeValues range){
    var s=(range.start-closePrice)/rsme;
    var e=(range.end-closePrice)/rsme;
    var simpson = SimpsonRule(
      function: '1/(2*pi*e^(x^2))^0.5',
      lowerBound: s,
      upperBound: e,
    );

    int d=widget.forecastPriceList[widget.currencyIndex].pricesList.indexWhere((element) => element.date==selectedDate)+1;

    return (simpson.integrate().result*100)*pow((100-(widget.forecastPriceList[widget.currencyIndex].errorPercentage))/100, d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(
                  context,
                  cryptocurrencyNames[widget.currencyIndex] + ' Forecasts',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Forecast\n',
                        style: kCardSmallTextStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Deviation\n',
                            style: kCardTextStyle,
                          ),
                          TextSpan(
                            text: '\$ '+kDashboardPriceDisplay(widget.forecastPriceList[widget.currencyIndex].errorValue),
                            style: kCardTextStyle2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: 120,
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
                                color: widget.forecastPriceList[widget.currencyIndex].errorPercentage<
                                    10
                                    ? kGreen
                                    : widget.forecastPriceList[widget.currencyIndex].errorPercentage<
                                    20
                                    ? kYellow
                                    : kRed,
                                animationType: AnimationType.ease,
                                enableAnimation: true,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.15,
                                sizeUnit: GaugeSizeUnit.factor,
                                value: (100-widget.forecastPriceList[widget.currencyIndex].errorPercentage),
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
                                        text: (100-widget.forecastPriceList[widget.currencyIndex].errorPercentage).roundToDouble().toString()
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
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return CurrencyForecastsGraph(widget.realPriceList,widget.forecastPriceList,widget.currencyIndex);
                            }));
                      },
                      icon: const Icon(
                        Icons.fullscreen,
                      ),
                      tooltip: 'Full Screen View',
                      alignment: Alignment.bottomRight,
                    ),
                  ],
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
                      zoomMode: charts.ZoomMode.x,
                    ),
                    primaryXAxis: charts.DateTimeAxis(
                      visibleMinimum: kMinDayInForecastGraph,
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
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Real Price',
                        color: kGraphColor1,
                        dataSource: getRealPrices(
                            currency: cryptocurrencies[widget.currencyIndex] +
                                '-USD'),
                        xValueMapper: (RealPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (RealPrice data, _) => data.closePrice,
                      ),
                      charts.LineSeries<ForecastPrice, DateTime>(
                        name: cryptocurrencies[widget.currencyIndex] +
                            ' Forecast Price',
                        color: kGraphColor2,
                        dataSource: getForecastPrices(
                            currency: cryptocurrencies[widget.currencyIndex]+
                                '-USD'),
                        xValueMapper: (ForecastPrice data, _) =>
                            DateTime.parse(data.date),
                        yValueMapper: (ForecastPrice data, _) => data.closePrice,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40,),
                /*RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Probability of ',
                    style: kCardSmallTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: cryptocurrencies[widget.currencyIndex],
                        style: kCardTextStyle2,
                      ),
                  TextSpan(
                    text: ' price on',
                    style: kCardSmallTextStyle,
                  ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),*/
                SizedBox(
                  height: 80,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        selectedDate = dates.elementAt(value);
                        closePrice=widget.forecastPriceList[widget.currencyIndex].pricesList.where((element) => element.date==selectedDate).first.closePrice;
                        rsme=widget.forecastPriceList[widget.currencyIndex].errorValue;
                        priceRange=SfRangeValues(closePrice-3*rsme, closePrice+3*rsme);
                         // selectedRange.end>priceRange.end?selectedRange=SfRangeValues(selectedRange.start, priceRange.end):selectedRange=SfRangeValues(selectedRange.start, selectedRange.end);
                         // selectedRange.start<priceRange.start?selectedRange=SfRangeValues(priceRange.start, selectedRange.end):selectedRange=SfRangeValues(selectedRange.start, selectedRange.end);
                      });
                    },
                    diameterRatio: 1.2,
                    itemExtent: 32.0,
                    children: List<Widget>.generate(
                        dates.length,
                            (int index) {
                          return Center(
                            child: Text(
                              dates.elementAt(index),
                              style: kCardTextStyle,
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(height: 20,),
                /*RangeSlider(
                  activeColor: kAccentColor1,
                  inactiveColor: kTransparentColor1,
                  values: selectedRange,
                  //divisions: 8000,
                  min: priceRange.start,
                  max: priceRange.end,
                  labels: RangeLabels(
                    kCurrencyPriceDisplay(selectedRange.start),
                    kCurrencyPriceDisplay(selectedRange.end),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      selectedRange = values;
                    });
                  },
                ),*/
                SfRangeSelector(
                  min: priceRange.start,
                  max: priceRange.end,
                  initialValues: selectedRange,
                  activeColor: kAccentColor1,
                  inactiveColor: kTransparentColor7,
                  enableTooltip: true,
                  tooltipShape: const SfPaddleTooltipShape(),
                  onChanged: (dynamic values) {
                    setState(() {
                      selectedRange = values;
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: charts.SfCartesianChart(
                      plotAreaBorderWidth:0,
                      primaryXAxis: charts.NumericAxis(
                        visibleMinimum: priceRange.start,
                        visibleMaximum: priceRange.end,
                        isVisible: false,
                      ),
                      primaryYAxis: charts.NumericAxis(
                        visibleMaximum: 0.4,
                        isVisible: false,
                      ),
                      series: <charts.ChartSeries>[
                        charts.SplineAreaSeries<GraphData, double>(
                          name: 'Probability Distribution',
                          color: kTransparentColor2,
                          dataSource: [
                            GraphData(valueOne: closePrice-3.0*rsme, valueTwo: 0.004),
                            GraphData(valueOne: closePrice-2.0*rsme, valueTwo: 0.054),
                            GraphData(valueOne: closePrice-1.0*rsme, valueTwo: 0.242),
                            GraphData(valueOne: closePrice, valueTwo: 0.399),
                            GraphData(valueOne: closePrice+1.0*rsme, valueTwo: 0.242),
                            GraphData(valueOne: closePrice+2.0*rsme, valueTwo: 0.054),
                            GraphData(valueOne: closePrice+3.0*rsme, valueTwo: 0.004),
                          ],
                          xValueMapper: (GraphData data, _) => data.valueOne,
                          yValueMapper: (GraphData data, _) => data.valueTwo,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 50,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-250,
                      child: Text(
                        '\$ '+kDashboardPriceDisplay(selectedRange.start),
                        style: kCardTextStyle,
                      ),
                    ),
                    //SizedBox(width: MediaQuery.of(context).size.width-50,),
                    SizedBox(
                      width: 150,
                    child:Text(
                      '\$ '+kDashboardPriceDisplay(selectedRange.end),
                      style: kCardTextStyle,
                    ),),
                  ],
                ),
                const SizedBox(height: 10,),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Probability of',
                    style: kCardSmallTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: ' price being in the range\n',
                        style: kCardSmallTextStyle,
                      ),
                      TextSpan(
                        text: getProbabilityValue(selectedRange).toStringAsFixed(2)+'%',
                        style: kCardTextStyle2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
