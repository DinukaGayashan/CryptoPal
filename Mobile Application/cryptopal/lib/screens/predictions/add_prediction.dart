import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class AddPrediction extends StatefulWidget {
  const AddPrediction(this.currentUser, {Key? key}) : super(key: key);

  final UserAccount currentUser;
  @override
  State<AddPrediction> createState() => _AddPredictionState();
}

class _AddPredictionState extends State<AddPrediction> {
  final _firestore = FirebaseFirestore.instance;
  final String today=DateTime.now().toString().split(' ')[0];
  late int selectedCrypto = 0;
  late double predictionPrice;
  late DateTime predictionDate = DateTime.now().add(const Duration(days: 1));

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
                children: <Widget>[
                  topBar(
                    context,
                    'Add Prediction',
                  ),
                  const SizedBox(
                    height: 20.0,
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
                          cryptocurrencyNames.length,
                              (int index) {
                            return Center(
                              child: Text(
                                cryptocurrencyNames[index] +
                                    ' ' +
                                    cryptocurrencies[index],
                                style: kSubjectStyle,
                              ),
                            );
                          }),
                    ),
                  ),
                  /*SizedBox(
                    child: CupertinoButton(
                      onPressed: () {
                        showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) => Container(
                                  height: 300,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  color: kTransparentColor4,
                                  child: SafeArea(
                                    child: CupertinoPicker(
                                      onSelectedItemChanged: (int value) {
                                        setState(() {
                                          selectedCrypto = value;
                                        });
                                      },
                                      diameterRatio: 1.2,
                                      itemExtent: 32.0,
                                      children: List<Widget>.generate(
                                          cryptocurrencyNames.length,
                                          (int index) {
                                        return Center(
                                          child: Text(
                                            cryptocurrencyNames[index] +
                                                ' ' +
                                                cryptocurrencies[index],
                                            style: kCardTextStyle,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ));
                      },
                      child: Text(
                        cryptocurrencyNames[selectedCrypto] +
                            ' ' +
                            cryptocurrencies[selectedCrypto],
                        style: kSubjectStyle,
                      ),
                    ),
                  ),*/
                  const SizedBox(
                    height: 40.0,
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
                    height: 80.0,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CupertinoButton(
                      color: kAccentColor1,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onPressed: () async {
                        String date = predictionDate.toString().split(' ')[0];
                        String currency =
                            cryptocurrencies[selectedCrypto] + '-USD';
                        double price = predictionPrice.toDouble();

                        currentUser.predictions.removeWhere((item) =>
                            item.predictionCurrency == currency &&
                            item.predictionDate == date);
                        currentUser.futurePredictions.removeWhere((item) =>
                            item.predictionCurrency == currency &&
                            item.predictionDate == date);

                        currentUser.predictions
                            .add(Prediction(today, date, currency, price, 0, 0));
                        currentUser.futurePredictions
                            .add(Prediction(today, date, currency, price, 0, 0));

                        try {
                          await _firestore
                              .collection('users')
                              .doc(widget.currentUser.user?.uid)
                              .collection('predictions')
                              .doc(date + ' ' + currency)
                              .set({
                            'predictedDate':today,
                            'predictionDate': date,
                            'predictionCurrency': currency,
                            'predictionClosePrice': predictionPrice.toDouble(),
                          });
                          snackBar(context,
                              message: 'Prediction successfully added.',
                              color: kGreen);
                        } catch (e) {
                          snackBar(context, message: e.toString(), color: kRed);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Add Prediction',
                        style: kButtonTextStyle,
                      ),
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
