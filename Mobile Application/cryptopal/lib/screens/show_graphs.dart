import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:cryptopal/utility/database_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class ShowGraphs extends StatefulWidget {
  const ShowGraphs(this.realPriceList, this.coinIndex, {Key? key})
      : super(key: key);
  static const String id = 'ShowGraphs';
  final List<RealPricesOfACurrency> realPriceList;
  final int coinIndex;

  @override
  State<ShowGraphs> createState() => _ShowGraphsState();
}

class _ShowGraphsState extends State<ShowGraphs> {

  bool ohlcCheckBox=false,closePriceCheckBox=true,openPriceCheckBox=true;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      cryptocurrencyNames[widget.coinIndex],
                      style: kSubSubjectStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
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
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: ohlcCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              ohlcCheckBox = value!;
                            });
                          }),
                      const Text(
                        'OHLC',
                        style: kCardSmallTextStyle,
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Checkbox(
                          value: closePriceCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              closePriceCheckBox = value!;
                            });
                          }),
                      const Text(
                        'Close',
                        style: kCardSmallTextStyle,
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Checkbox(
                          value: openPriceCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              openPriceCheckBox = value!;
                            });
                          }),
                      const Text(
                        'Open',
                        style: kCardSmallTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 350.0,
                    child: charts.SfCartesianChart(
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
                      legend: charts.Legend(
                          isVisible: true,
                          //position: charts.LegendPosition()
                      ),
                      indicators: <charts.TechnicalIndicators<dynamic, dynamic>>[
                        charts.EmaIndicator<dynamic, dynamic>(
                          seriesName: 'HiloOpenClose',
                          valueField: 'high',)],
                      series: <charts.ChartSeries>[
                        charts.LineSeries<RealPrice, DateTime>(
                          isVisible: closePriceCheckBox,
                          name: cryptocurrencies[widget.coinIndex]+' Close Price',
                          dataSource: getRealPrices(currency: cryptocurrencies[widget.coinIndex]+'-USD'),
                          xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.closePrice,
                          //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                        ),
                        charts.LineSeries<RealPrice, DateTime>(
                          isVisible: openPriceCheckBox,
                          name: cryptocurrencies[widget.coinIndex]+' Open Price',
                          dataSource: getRealPrices(currency: cryptocurrencies[widget.coinIndex]+'-USD'),
                          xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.openPrice,
                        ),
                        charts.CandleSeries<RealPrice, DateTime>(
                          isVisible: ohlcCheckBox,
                          name: cryptocurrencies[widget.coinIndex]+' OHLC Prices',
                          dataSource: getRealPrices(currency: cryptocurrencies[widget.coinIndex]+'-USD'),
                          xValueMapper: (RealPrice data, _) => DateTime.parse(data.date),
                          lowValueMapper: (RealPrice data, _) => data.lowestPrice,
                          highValueMapper: (RealPrice data, _) => data.highestPrice,
                          openValueMapper: (RealPrice data, _) => data.openPrice,
                          closeValueMapper: (RealPrice data, _) => data.closePrice,
                          enableSolidCandles: true,
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
    );
  }
}
