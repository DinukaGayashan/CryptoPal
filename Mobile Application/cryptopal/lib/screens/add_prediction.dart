import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:glass/glass.dart';

class AddPrediction extends StatefulWidget {
  const AddPrediction(this.currentUser, {Key? key}) : super(key: key);

  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return ScaleTransition(
      scale: animation,
      child: AddPrediction(currentUser),
    );FadeTransition(opacity: animation, child: AddPrediction(currentUser));
  }

  static const String id='AddPrediction';
  final UserAccount currentUser;
  @override
  State<AddPrediction> createState() => _AddPredictionState();
}

class _AddPredictionState extends State<AddPrediction> {

  final _firestore=FirebaseFirestore.instance;
  late int selectedCrypto=0;
  late double predictionPrice;
  late DateTime predictionDate=DateTime.now().add(const Duration(days:1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      /*appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: logoAppBar(context),
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          child: glassCard(context, Column(
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              const Center(
                child: Text(
                  'Add Prediction',
                  style: kCardTextStyle,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                child: CupertinoButton(
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => Container(
                          height: 300,
                          padding: const EdgeInsets.only(top: 10.0),
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          color: kTransparentColor,
                          child: SafeArea(
                            //top: false,
                            child: CupertinoPicker(
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  selectedCrypto=value;
                                });
                              },
                              diameterRatio: 1.2,
                              itemExtent: 32.0,
                              children: List<Widget>.generate(cryptocurrencyNames.length, (int index) {
                                return Center(
                                  child: Text(
                                    cryptocurrencyNames[index]+' ('+cryptocurrencies[index]+')',
                                    style: kButtonTextStyle,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ));
                  },
                  child: Text(
                    cryptocurrencyNames[selectedCrypto],
                    style: kSubjectStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 100,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now().add(const Duration(days:1)),
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime value) {
                    predictionDate=value;
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
                      onChanged: (value){
                        predictionPrice=double.parse(value);
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
              MaterialButton(
                color: kAccentColor3,
                height:40.0,
                minWidth: double.infinity,
                onPressed: () async {
                  try{
                    await _firestore.collection('users').doc(widget.currentUser.user?.uid)
                        .collection('predictions')
                        .doc(predictionDate.toString().split(' ')[0]+' '+cryptocurrencies[selectedCrypto]+'-USD')
                        .set(
                        {
                          'predictedDate':predictionDate.toString().split(' ')[0],
                          'predictedCurrency':cryptocurrencies[selectedCrypto]+'-USD',
                          'predictedClosePrice': predictionPrice.toDouble(),
                        }
                    );
                  }
                  catch(e){
                    print(e);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add Prediction',
                  style: kButtonTextStyle,
                ),
              ).asGlass(),
            ],
          ),
          ),
        ),
      ),
    );
  }
}