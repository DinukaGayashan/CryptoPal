import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';
import 'package:cryptopal/utility/cryptocurrency_data.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cryptopal/screens/dashboard/dashboard_loading.dart';
import '../../utility/constants.dart';
import '../../utility/widgets.dart';

class SelectCryptocurrencies extends StatefulWidget {
  const SelectCryptocurrencies({Key? key}) : super(key: key);

  @override
  State<SelectCryptocurrencies> createState() => _SelectCryptocurrenciesState();
}

class _SelectCryptocurrenciesState extends State<SelectCryptocurrencies> {

  final _firestore = FirebaseFirestore.instance;
  late Map<String,bool> stateOfCryptocurrencies={};
  late List<String> cryptocurrencyList=[];

  void initializeCryptocurrencyList(){
    stateOfCryptocurrencies=Map.fromIterables(cryptocurrencies, List.filled(cryptocurrencies.length, false));
    for(var c in selectedCryptocurrencies){
      stateOfCryptocurrencies[c]=true;
    }
    cryptocurrencyList=stateOfCryptocurrencies.keys.toList();
  }

  void reorderCryptocurrencyList(int oldIndex,int newIndex){
    setState(() {
      if(newIndex>oldIndex){
        newIndex-=1;
      }
      final items =cryptocurrencyList.removeAt(oldIndex);
      cryptocurrencyList.insert(newIndex, items);
    });
  }

  @override
  void initState() {
    initializeCryptocurrencyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            ReorderableListView(
              header: Column(
                children: [
                  topBar(context, 'Select Cryptocurrencies'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Select and reorder cryptocurrencies as required.',
                    style: kInstructionStyle,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              onReorder: (oldIndex, newIndex){
                reorderCryptocurrencyList(oldIndex, newIndex);
              },
              shrinkWrap: true,
              footer: const SizedBox(
                height: 60,
              ),
              children: [
                for(final currency in cryptocurrencyList)
                  Padding(
                    key: ValueKey(currency),
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/cryptocoin_icons/color/${currency.toLowerCase()}.svg',
                                    width: 45.0,
                                    height: 45.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        currency,
                                        style: kCardTextStyle,
                                      ),
                                      Text(
                                        cryptocurrencyNames[currency].toString(),
                                        style: kCardSmallTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            CupertinoSwitch(
                              activeColor: kTransparentColor2,
                              value: stateOfCryptocurrencies[currency]!,
                              onChanged: (value){
                                stateOfCryptocurrencies[currency]=value;
                                setState(() {
                                  stateOfCryptocurrencies;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          SizedBox(
            width: MediaQuery.of(context).size.width-33,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: kBackgroundColor,
                      title: const Text(
                        'Confirm Cryptocurrency Selection',
                        style: kInstructionStyle2,
                      ),
                      content: const Text(
                        "Confirm the cryptocurrency selection.\nApp will restart to apply changes.",
                        style: kInstructionStyle,
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            "Cancel",
                            style: kLinkStyle,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Confirm",
                            style: kLinkStyle,
                          ),
                          onPressed: () async {
                            List<String> selectedList=[];
                            for(var currency in cryptocurrencyList){
                              if(stateOfCryptocurrencies[currency]==true){
                                selectedList.add(currency);
                              }
                            }
                            try{
                              await _firestore
                                  .collection('users')
                                  .doc(currentUser.user.uid)
                                  .set(
                                {
                                  'selectedCryptocurrencies': selectedList,
                                },
                                SetOptions(merge: true),);
                            }
                            catch(e){
                              snackBar(context, message: e.toString(), color: kRed);
                            }
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil(DashboardLoading.id, (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: kAccentColor1,
              label: const Text(
                'Confirm',
                style: kButtonTextStyle,
              ),

            ),
      ),
    );
  }
}