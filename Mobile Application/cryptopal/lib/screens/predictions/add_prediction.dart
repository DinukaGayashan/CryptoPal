import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/utility/real_price_data.dart';
import 'package:hashtagable/hashtagable.dart';

class AddPrediction extends StatefulWidget {
  const AddPrediction(this.currentUser, this.realPriceList, {Key? key})
      : super(key: key);

  final UserAccount currentUser;
  final List<RealPricesOfACurrency> realPriceList;
  @override
  State<AddPrediction> createState() => _AddPredictionState();
}

class _AddPredictionState extends State<AddPrediction> {
  final _firestore = FirebaseFirestore.instance;
  final String today = DateTime.now().toString().split(' ')[0];
  late int selectedCrypto = 0;
  late double predictionPrice;
  late DateTime predictionDate = DateTime.now().add(const Duration(days: 1));
  late String? keywords = null;

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
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  topBar(
                    context,
                    'Add Prediction',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100,
                    child: CupertinoPicker(
                      onSelectedItemChanged: (int value) {
                        setState(() {
                          selectedCrypto = value;
                        });
                      },
                      diameterRatio: 1.2,
                      itemExtent: 32.0,
                      children: List<Widget>.generate(
                          selectedCryptocurrencies.length, (int index) {
                        return Center(
                          child: Text(
                            selectedCryptocurrencies[index],
                            style: kSubjectStyle,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 100,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime:
                          DateTime.now().add(const Duration(days: 1)),
                      minimumDate: DateTime.now(),
                      onDateTimeChanged: (DateTime value) {
                        predictionDate = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text:
                            '${selectedCryptocurrencies[selectedCrypto]} Close Price',
                        textStyle: kCardSmallTextStyle,
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                        enableMouseWheelZooming: true,
                        zoomMode: ZoomMode.x,
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
                          color: widget.realPriceList[selectedCrypto]
                                      .priceIncreasePercentage >
                                  0
                              ? kGreen
                              : kRed,
                          name:
                              '${selectedCryptocurrencies[selectedCrypto]} Close Price',
                          dataSource: getRealPrices(
                              currency:
                                  '${selectedCryptocurrencies[selectedCrypto]}-USD'),
                          xValueMapper: (RealPrice data, _) =>
                              DateTime.parse(data.date),
                          yValueMapper: (RealPrice data, _) => data.closePrice,
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'Last close price (${widget.realPriceList.last.pricesList.last.date})\n',
                      style: kCardSmallTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.realPriceList[selectedCrypto].pricesList
                              .last.closePrice
                              .toString(),
                          style: kCardTextStyle2,
                        ),
                        const TextSpan(
                          text: ' USD',
                          style: kCardSmallTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
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
                        width: MediaQuery.of(context).size.width - 230,
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
                          onChanged: (value) {
                            predictionPrice = double.parse(value);
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
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Description',
                        style: kInstructionStyle2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 170,
                        child: HashTagTextField(
                          decorateAtSign: true,
                          decoratedStyle: kCardSmallTextStyle,
                          basicStyle: kTransparentStyle,
                          cursorHeight: 17,
                          cursorColor: kAccentColor1,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kAccentColor1),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kAccentColor3),
                            ),
                            hintText: '#hashtags',
                            hintStyle: kTransparentStyle,
                          ),
                          onChanged: (text) {
                            keywords = text;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CupertinoButton(
                      color: kAccentColor1,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onPressed: () async {
                        try {
                          if (predictionPrice >= 0) {
                            String date =
                                predictionDate.toString().split(' ')[0];
                            String currency =
                                '${selectedCryptocurrencies[selectedCrypto]}-USD';
                            double price = predictionPrice.toDouble();

                            currentUser.predictions.removeWhere((item) =>
                                item.predictionCurrency == currency &&
                                item.predictionDate == date);
                            currentUser.futurePredictions.removeWhere((item) =>
                                item.predictionCurrency == currency &&
                                item.predictionDate == date);

                            currentUser.predictions.add(Prediction(
                                today, date, currency, price, keywords, 0, 0));
                            currentUser.futurePredictions.add(Prediction(
                                today, date, currency, price, keywords, 0, 0));

                            try {
                              await _firestore
                                  .collection('users')
                                  .doc(widget.currentUser.user.uid)
                                  .collection('predictions')
                                  .doc('$date $currency')
                                  .set({
                                'predictedDate': today,
                                'predictionDate': date,
                                'predictionCurrency': currency,
                                'predictionClosePrice': price,
                                'predictionKeywords': keywords,
                                'errorValue': null,
                              });
                              snackBar(context,
                                  message: 'Prediction successfully added.',
                                  color: kGreen);
                              Navigator.pop(context);
                            } catch (e) {
                              snackBar(context,
                                  message: e.toString(), color: kRed);
                            }
                          } else {
                            snackBar(context,
                                message: 'Prediction price cannot be negative.',
                                color: kRed);
                          }
                        } catch (e) {
                          snackBar(context,
                              message: 'Prediction closing price required.',
                              color: kRed);
                        }
                      },
                      child: const Text(
                        'Add Prediction',
                        style: kButtonTextStyle,
                      ),
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
