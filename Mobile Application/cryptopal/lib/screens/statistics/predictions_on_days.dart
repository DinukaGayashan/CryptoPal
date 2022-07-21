import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:cryptopal/utility/real_price_data.dart';

import '../predictions/currency_prediction_graph.dart';

class PredictionsOnDays extends StatefulWidget {
  const PredictionsOnDays(this.predictionsOnDays, this.realPriceList, {Key? key}) : super(key: key);
  final Map<String,List<Prediction>> predictionsOnDays;
  final List<RealPricesOfACurrency> realPriceList;

  @override
  State<PredictionsOnDays> createState() => _PredictionsOnDaysState();
}

class _PredictionsOnDaysState extends State<PredictionsOnDays> {
  late String selectedDate=DateTime.now().toString().split(' ')[0];
  late List<String> dates;

  List<GraphData> getPredictionCountOnDays(){
    List<GraphData> count=[];
    for(var d in dates){
      count.add(GraphData(valueOne: DateTime.parse(d), valueTwo: widget.predictionsOnDays[d]?.length));
    }
    return count;
  }

  void getHistoryDates(){
    dates=widget.predictionsOnDays.keys.toList();
    dates.sort();
    dates=dates.reversed.toList();
  }

  int getCryptocurrencyIndex(String predictionCurrency){
    int i=0;
    for(i=0;i<selectedCryptocurrencies.length;i++){
      if(selectedCryptocurrencies[i]==predictionCurrency.split('-')[0]){
        break;
      }
    }
    return i;
  }

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
  
  RealPrice? getRealPrice({required String currency, required String date}) {
    final List<RealPrice> priceList =
    getRealPrices(currency: currency + '-USD');
    RealPrice x = RealPrice(date, 0, 0, 0, 0);
    for (var i in priceList) {
      if (i.date == date) {
        x = i;
      }
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    getHistoryDates();

    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Predictions On Dates'),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableMouseWheelZooming: true,
                      zoomMode: ZoomMode.x,
                    ),
                    primaryXAxis: DateTimeAxis(
                      visibleMinimum: kMinDayInSmallGraph,
                    ),
                    plotAreaBorderWidth: 1,
                    enableAxisAnimation: true,
                    crosshairBehavior: CrosshairBehavior(
                      enable: true,
                    ),
                      series: <ChartSeries>[
                        ColumnSeries<GraphData, DateTime>(
                          name: 'Number of predictions',
                            color:kGraphColor1,
                            dataSource: getPredictionCountOnDays(),
                            xValueMapper: (GraphData data, _) => data.valueOne,
                            yValueMapper: (GraphData data, _) => data.valueTwo,
                        ),
                      ],
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  height: 80,
                child: CupertinoPicker(
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      selectedDate = dates.elementAt(value);
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
                const SizedBox(height: 15,),
                for(var prediction in widget.predictionsOnDays[selectedDate]!)
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    child: glassCard(
                      context,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              child: Text(
                                prediction.predictionDate+'\n'+prediction.predictionCurrency,
                                style: kCardLargeTextStyle,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Prediction Price\n',
                                style: kCardSmallTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: kCurrencyPriceDisplay(prediction.predictionClosePrice)+' \$',
                                    style: kCardTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CurrencyPredictionGraph(getCryptocurrencyIndex(prediction.predictionCurrency), widget.realPriceList, prediction);
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
      ),
    );
  }
}
