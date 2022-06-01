import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool _closePriceCheckBox = true, _openPriceCheckBox = false;

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
                        cryptocurrencyNames[widget.coinIndex],
                        style: kSubSubjectStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/cryptocoin_icons/color/' +
                        cryptocurrencies[widget.coinIndex].toLowerCase() +
                        '.svg',
                    width: 60.0,
                    height: 60.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
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
                                    cryptocurrencyNames[widget.coinIndex],
                                    style: kSubSubjectStyle,
                                    textAlign: TextAlign.center,
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
                                    text: 'Open Close Prices',
                                    textStyle: kCardSmallTextStyle,
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
                                  tooltipBehavior: charts.TooltipBehavior(
                                    enable: true,
                                  ),
                                  crosshairBehavior: charts.CrosshairBehavior(
                                    enable: true,
                                  ),
                                  legend: charts.Legend(
                                    isVisible: true,
                                    overflowMode: charts.LegendItemOverflowMode.wrap,
                                    position: charts.LegendPosition.bottom,
                                  ),
                                  series: <charts.ChartSeries>[
                                    charts.LineSeries<RealPrice, DateTime>(
                                      isVisible: _closePriceCheckBox,
                                      name: cryptocurrencies[widget.coinIndex] +
                                          ' Close Price',
                                      dataSource: getRealPrices(
                                          currency:
                                          cryptocurrencies[widget.coinIndex] +
                                              '-USD'),
                                      xValueMapper: (RealPrice data, _) =>
                                          DateTime.parse(data.date),
                                      yValueMapper: (RealPrice data, _) =>
                                      data.closePrice,
                                      //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                                    ),
                                    charts.LineSeries<RealPrice, DateTime>(
                                      isVisible: _openPriceCheckBox,
                                      name: cryptocurrencies[widget.coinIndex] +
                                          ' Open Price',
                                      dataSource: getRealPrices(
                                          currency:
                                          cryptocurrencies[widget.coinIndex] +
                                              '-USD'),
                                      xValueMapper: (RealPrice data, _) =>
                                          DateTime.parse(data.date),
                                      yValueMapper: (RealPrice data, _) =>
                                      data.openPrice,
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
                        text: 'Open Close Prices',
                        textStyle: kCardSmallTextStyle,
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
                      tooltipBehavior: charts.TooltipBehavior(
                        enable: true,
                      ),
                      crosshairBehavior: charts.CrosshairBehavior(
                        enable: true,
                      ),
                      legend: charts.Legend(
                        isVisible: true,
                        overflowMode: charts.LegendItemOverflowMode.wrap,
                        position: charts.LegendPosition.bottom,
                      ),
                      series: <charts.ChartSeries>[
                        charts.LineSeries<RealPrice, DateTime>(
                          isVisible: _closePriceCheckBox,
                          name: cryptocurrencies[widget.coinIndex] +
                              ' Close Price',
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.coinIndex] + '-USD'),
                          xValueMapper: (RealPrice data, _) =>
                              DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.closePrice,
                          //pointColorMapper: (RealPrice data, _) => data.closePrice>data.openPrice?kGreen:kRed,
                        ),
                        charts.LineSeries<RealPrice, DateTime>(
                          isVisible: _openPriceCheckBox,
                          name: cryptocurrencies[widget.coinIndex] +
                              ' Open Price',
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.coinIndex] + '-USD'),
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
                      Checkbox(
                          activeColor: kAccentColor3,
                          value: _closePriceCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              _closePriceCheckBox = value!;
                            });
                          }),
                      const Text(
                        'Close Price',
                        style: kCardSmallTextStyle,
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      Checkbox(
                          activeColor: kAccentColor3,
                          value: _openPriceCheckBox,
                          onChanged: (bool? value) {
                            setState(() {
                              _openPriceCheckBox = value!;
                            });
                          }),
                      const Text(
                        'Open Price',
                        style: kCardSmallTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
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
                                    cryptocurrencyNames[widget.coinIndex],
                                    style: kSubSubjectStyle,
                                    textAlign: TextAlign.center,
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
                                  text: 'OHLC Prices',
                                  textStyle: kCardSmallTextStyle,
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
                                tooltipBehavior: charts.TooltipBehavior(
                                  enable: true,
                                ),
                                series: <charts.ChartSeries>[
                                  charts.CandleSeries<RealPrice, DateTime>(
                                    name: cryptocurrencies[widget.coinIndex] +
                                        ' OHLC Prices',
                                    dataSource: getRealPrices(
                                        currency:
                                            cryptocurrencies[widget.coinIndex] +
                                                '-USD'),
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
                        text: 'OHLC Prices',
                        textStyle: kCardSmallTextStyle,
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
                      tooltipBehavior: charts.TooltipBehavior(
                        enable: true,
                      ),
                      series: <charts.ChartSeries>[
                        charts.CandleSeries<RealPrice, DateTime>(
                          name: cryptocurrencies[widget.coinIndex] +
                              ' OHLC Prices',
                          dataSource: getRealPrices(
                              currency:
                                  cryptocurrencies[widget.coinIndex] + '-USD'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
