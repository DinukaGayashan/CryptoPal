import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/real_price_data.dart';

class CurrencyPredictionGraph extends StatelessWidget {
  const CurrencyPredictionGraph(this.currencyIndex, this.realPriceList, this.prediction, {Key? key}) : super(key: key);

  final int currencyIndex;
  final Prediction prediction;
  final List<RealPricesOfACurrency> realPriceList;

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
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: glassCard(context,
          Column(
            children: [
              topBar(context, cryptocurrencyNames[cryptocurrencies[currencyIndex]].toString()+' Prediction'),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-133,
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
                      dataSource: prediction.toList(prediction),
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
      ),
    );
  }
}
