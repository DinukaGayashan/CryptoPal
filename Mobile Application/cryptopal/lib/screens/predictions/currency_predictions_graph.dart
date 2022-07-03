import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/database_data.dart';

class CurrencyPredictionsGraph extends StatelessWidget {
  const CurrencyPredictionsGraph(this.currentUser, this.currencyIndex, this.realPriceList, {Key? key}) : super(key: key);

  static const String id = 'CurrencyPredictionsGraph';
  final UserAccount currentUser;
  final int currencyIndex;
  final List<RealPricesOfACurrency> realPriceList;

  List<Prediction> getUserPredictions ({required String currency,bool past=false}){
    List<Prediction> predictions=[];
    List<Prediction> predictionSnap=past?currentUser.pastPredictions:currentUser.predictions;
    if(currency=='all'){
      predictions=predictionSnap;
    }
    else{
      for(var prediction in predictionSnap){
        if(prediction.predictionCurrency==currency+'-USD'){
          predictions.add(prediction);
        }
      }
    }
    return predictions;
  }

  List<RealPrice> getRealPrices ({required String currency, int number=0}){
    List<RealPrice> realPrices=[];
    for(var type in realPriceList){
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
      child: glassCard(context,
         Column(
           children: [
             topBar(context, cryptocurrencyNames[currencyIndex]+' Predictions'),
             SizedBox(
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height-135,
               child: SfCartesianChart(
                 legend: Legend(
                   isVisible: true,
                   overflowMode: LegendItemOverflowMode.wrap,
                   position: LegendPosition.bottom,
                 ),
                 zoomPanBehavior: ZoomPanBehavior(
                   enablePinching: true,
                   enablePanning: true,
                   enableMouseWheelZooming: true,
                   zoomMode: ZoomMode.xy,
                 ),
                 primaryXAxis: DateTimeAxis(
                   visibleMinimum: kMinDayInGraph,
                 ),
                 primaryYAxis: NumericAxis(),
                 plotAreaBorderWidth: 1,
                 enableAxisAnimation: true,
                 crosshairBehavior: CrosshairBehavior(
                   enable: true,
                 ),
                 tooltipBehavior: TooltipBehavior(
                   enable: true,
                 ),
                 series: <ChartSeries>[
                   LineSeries<RealPrice, DateTime>(
                     name: cryptocurrencies[currencyIndex]+' Close Price',
                     color: kGraphColor1,
                     dataSource: getRealPrices(currency: cryptocurrencies[currencyIndex]+'-USD'),
                     xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                     yValueMapper: (RealPrice data, _) => data.closePrice,
                   ),
                   LineSeries<Prediction, DateTime>(
                     name: cryptocurrencies[currencyIndex]+' Prediction',
                     color: kGraphColor2,
                     dataSource: getUserPredictions(currency: cryptocurrencies[currencyIndex]),
                     xValueMapper: (Prediction data, _) => data.predictionDateAsDate,
                     yValueMapper: (Prediction data, _) => data.predictionClosePrice,
                     markerSettings: const MarkerSettings(
                       isVisible: true,
                     ),
                   ),
                 ],
               ),
             ),

           ],
         ),
      ),
    );
  }
}
