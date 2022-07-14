import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import 'currency_ohlc_graph.dart';
import 'currency_open_close_graph.dart';

class CurrencyMarketGraphs extends StatefulWidget {
  const CurrencyMarketGraphs(this.realPriceList, this.currencyIndex, {Key? key})
      : super(key: key);
  static const String id = 'CurrencyMarketGraphs';
  final List<RealPricesOfACurrency> realPriceList;
  final int currencyIndex;

  @override
  State<CurrencyMarketGraphs> createState() => _CurrencyMarketGraphsState();
}

class _CurrencyMarketGraphsState extends State<CurrencyMarketGraphs> {
  bool _showClosePrice = true, _showOpenPrice = false;

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
                  topBar(context, cryptocurrencyNames[widget.currencyIndex]+' ('+cryptocurrencies[widget.currencyIndex]+')'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return CurrencyOpenCloseGraph(widget.currencyIndex, widget.realPriceList, _showClosePrice, _showOpenPrice);
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
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: 'Open Close Prices',
                        textStyle: kCardSmallTextStyle,
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        enableMouseWheelZooming: true,
                        zoomMode: ZoomMode.xy,
                      ),
                      primaryXAxis: DateTimeAxis(
                        visibleMinimum: kMinDayInExtendedGraph,
                        dateFormat: DateFormat.yMd(),
                      ),
                      primaryYAxis: NumericAxis(),
                      plotAreaBorderWidth: 1,
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ),
                      crosshairBehavior: CrosshairBehavior(
                        enable: true,
                      ),
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.bottom,
                      ),
                      series: <ChartSeries>[
                        LineSeries<RealPrice, DateTime>(
                          isVisible: _showClosePrice,
                          name: cryptocurrencies[widget.currencyIndex] +
                              ' Close Price',
                          color: kGraphColor1,
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.currencyIndex] + '-USD'),
                          xValueMapper: (RealPrice data, _) =>
                              DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.closePrice,
                          //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                        ),
                        LineSeries<RealPrice, DateTime>(
                          isVisible: _showOpenPrice,
                          name: cryptocurrencies[widget.currencyIndex] +
                              ' Open Price',
                          color: kGraphColor2,
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.currencyIndex] + '-USD'),
                          xValueMapper: (RealPrice data, _) =>
                              DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.openPrice,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(_showClosePrice?kAccentColor3:Colors.transparent),
                            ),
                          onPressed: (){
                            setState(() {
                              if(_showClosePrice){
                                _showClosePrice = _showOpenPrice?false:true;
                                if(_showOpenPrice==false){
                                  snackBar(context, message: 'Select at least one graph to display.', color: kYellow);
                                }
                              }else{
                                _showClosePrice = true;
                              }
                            });
                          },
                          child: const Text(
                            'Close Price',
                            style: kCardSmallTextStyle,
                          ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(_showOpenPrice?kAccentColor3:Colors.transparent),
                        ),
                        onPressed: (){
                          setState(() {
                            if(_showOpenPrice){
                              _showOpenPrice = _showClosePrice?false:true;
                              if(_showClosePrice==false){
                                snackBar(context, message: 'Select at least one graph to display.', color: kYellow);
                              }
                            }else{
                              _showOpenPrice = true;
                            }
                          });
                        },
                        child: const Text(
                          'Open Price',
                          style: kCardSmallTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return CurrencyOHLCGraph(widget.currencyIndex, widget.realPriceList);
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
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: 'OHLC Prices',
                        textStyle: kCardSmallTextStyle,
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        enableMouseWheelZooming: true,
                        zoomMode: ZoomMode.xy,
                      ),
                      primaryXAxis: DateTimeAxis(
                        visibleMinimum: kMinDayInExtendedGraph,
                        dateFormat: DateFormat.yMd(),
                      ),
                      primaryYAxis: NumericAxis(),
                      plotAreaBorderWidth: 1,
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ),
                      series: <ChartSeries>[
                        CandleSeries<RealPrice, DateTime>(
                          name: cryptocurrencies[widget.currencyIndex] +
                              ' OHLC Prices',
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.currencyIndex] + '-USD'),
                          xValueMapper: (RealPrice data, _) =>
                              DateTime.parse(data.date),
                          lowValueMapper: (RealPrice data, _) =>
                              data.lowestPrice,
                          highValueMapper: (RealPrice data, _) =>
                              data.highestPrice,
                          openValueMapper: (RealPrice data, _) =>
                              data.openPrice,
                          closeValueMapper: (RealPrice data, _) =>
                              data.closePrice,
                          enableSolidCandles: true,
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
      ),
    );
  }
}
