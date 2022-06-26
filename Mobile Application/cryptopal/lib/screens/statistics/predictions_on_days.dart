import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import 'package:cryptopal/utility/user_account.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionsOnDays extends StatefulWidget {
  const PredictionsOnDays(this.predictionsOnDays, {Key? key}) : super(key: key);
  final Map<String,List<Prediction>> predictionsOnDays;

  @override
  State<PredictionsOnDays> createState() => _PredictionsOnDaysState();
}

class _PredictionsOnDaysState extends State<PredictionsOnDays> {
  late String selectedDate=widget.predictionsOnDays.keys.first;
  late List<String> dates;

  List<GraphData> getPredictionCountOnDays(){
    List<GraphData> count=[];
    for(var d in dates){
      count.add(GraphData(date: DateTime.parse(d), count: widget.predictionsOnDays[d]?.length));
    }
    return count;
  }

  void getHistoryDates(){
    dates=widget.predictionsOnDays.keys.toList();
    dates.sort();
    dates=dates.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    getHistoryDates();

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                            dataSource: getPredictionCountOnDays(),
                            xValueMapper: (GraphData data, _) => data.date,
                            yValueMapper: (GraphData data, _) => data.count,
                        ),

                      ],
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(height: 60,
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
                const SizedBox(height: 10,),
                for(var prediction in widget.predictionsOnDays[selectedDate]!)
                  GestureDetector(
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
                                style: kCardTextStyle,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Predicted Price\n',
                                style: kCardSmallTextStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: kCurrencyPriceDisplay(prediction.predictionClosePrice),
                                    style: kCardTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GraphData{
  late DateTime date;
  late int? count;

  GraphData({required this.date,required this.count});
}