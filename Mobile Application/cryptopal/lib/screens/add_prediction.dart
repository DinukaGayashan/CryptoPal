import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class add_prediction extends StatefulWidget {
  const add_prediction( {Key? key}) : super(key: key);
  static const String id='add_prediction';
  //final UserAccount currentUser;

  @override
  State<add_prediction> createState() => _add_predictionState();
}

class _add_predictionState extends State<add_prediction> {

  late int _selectedCrypto=0;
  late double predictionPrice;
  late DateTime predictionDate=DateTime.now().add(const Duration(days:1));
  final _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  late final User? user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    try{
      user= _auth.currentUser;
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: logoAppBar(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    'Add Prediction',
                    style: kSubSubjectStyle,
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
                              top: false,
                              child: CupertinoPicker(
                                onSelectedItemChanged: (int value) {
                                  setState(() {
                                    _selectedCrypto=value;
                                  });
                                }, 
                                itemExtent: 32.0,
                                children: List<Widget>.generate(cryptocurrencyNames.length, (int index) {
                                  return Center(
                                    child: Text(
                                      cryptocurrencyNames[index],
                                      style: kButtonTextStyle,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ));
                      },
                    child: Text(
                      cryptocurrencyNames[_selectedCrypto],
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
                      width: 20.0,
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
                      width: 20.0,
                    ),
                    const Text(
                      'USD',
                      style: kInstructionStyle2,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                MaterialButton(
                  color: kAccentColor3,
                  height:40.0,
                  minWidth: double.infinity,
                  onPressed: () async {
                    try{
                      await _firestore.collection('users').doc(user?.uid)
                          .collection('predictions')
                          .doc(predictionDate.toString().split(' ')[0]+' '+cryptocurrencies[_selectedCrypto]+'-USD')
                          .set(
                          {
                            'predictedDate':predictionDate.toString().split(' ')[0],
                            'predictedCurrency':cryptocurrencies[_selectedCrypto]+'-USD',
                            'predictedClosePrice': predictionPrice,
                          }
                      );
                    }
                    catch(e){
                      print(e);
                    }
                  },
                  child: const Text(
                    'Add Prediction',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
