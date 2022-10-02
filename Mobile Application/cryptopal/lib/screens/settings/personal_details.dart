import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cryptopal/utility/user_account.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails(this.currentUser, {Key? key}) : super(key: key);
  final UserAccount currentUser;

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _firestore = FirebaseFirestore.instance;
  late String newName, newBirthday;
  final notEnteredString = 'Not shared';
  late Map<String, String> userDetails = {};
  final Map<String, String> availableQuestions = {
    'educationLevel': 'Your education level',
    'knowledgeLevels': 'Your knowledge level about cryptocurrency trading',
    'wayOfKnowing': 'How did you get to know about cryptocurrencies',
    'purposeOfInvesting': 'Main purpose of investing',
    'amountOfInvesting': 'Amount you are willing to invest',
  };
  late Map<String, dynamic> availableDetails = {
    'educationLevel': [notEnteredString, 'Student', 'Undergraduate', 'Other'],
    'knowledgeLevels': [
      notEnteredString,
      'Very Low',
      'Low',
      'Average',
      'High',
      'Very High',
      'Other'
    ],
    'wayOfKnowing': [
      notEnteredString,
      'From the internet',
      'From friends',
      'Other'
    ],
    'purposeOfInvesting': [
      notEnteredString,
      'Main income',
      'Sub investment',
      'Other'
    ],
    'amountOfInvesting': [
      notEnteredString,
      'less than \$10',
      'less than \$100',
      'less than \$1000',
      'Other'
    ],
  };

  Future<void> setUserDetails() async {
    final doc = await _firestore
        .collection('users')
        .doc(currentUser.user.uid)
        .collection('additionalDetails')
        .doc('answers')
        .get();

    for (var i in availableDetails.keys) {
      try {
        userDetails[i] = doc.data()![i];
      } catch (e) {
        userDetails[i] = notEnteredString;
      }
      setState(() {
        userDetails;
      });
    }
  }

  @override
  void initState() {
    setUserDetails();
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
            ListView(
              children: <Widget>[
                topBar(context, 'Personal Details'),
                const SizedBox(
                  height: 20.0,
                ),
                ListTile(
                  title: const Text(
                    'Username',
                    style: kTransparentStyle,
                  ),
                  subtitle: Text(
                    widget.currentUser.name.toString(),
                    style: kCardTextStyle,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: kTransparentColor3,
                      size: 18,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: kBackgroundColor,
                            title: const Text(
                              'Change Username',
                              style: kInstructionStyle2,
                            ),
                            content: SizedBox(
                              width: 200,
                              height: 35,
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: "Enter new username",
                                  hintStyle: kTransparentStyle,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kAccentColor3),
                                  ),
                                ),
                                textCapitalization: TextCapitalization.words,
                                style: kCardTextStyle,
                                cursorHeight: 20,
                                cursorColor: kBaseColor2,
                                autofocus: true,
                                onChanged: (value) {
                                  newName = value;
                                },
                              ),
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
                                  currentUser.name = newName;
                                  try {
                                    await _firestore
                                        .collection('users')
                                        .doc(currentUser.user.uid)
                                        .set(
                                      {
                                        'name': newName,
                                      },
                                      SetOptions(merge: true),
                                    );
                                    snackBar(context,
                                        message:
                                            'Username changed successfully.',
                                        color: kGreen);
                                  } catch (e) {
                                    snackBar(context,
                                        message: e.toString(), color: kRed);
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Email',
                    style: kTransparentStyle,
                  ),
                  subtitle: Text(
                    (widget.currentUser.user.email).toString(),
                    style: kCardTextStyle,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Birthday',
                    style: kTransparentStyle,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMEd()
                        .format(DateTime.parse((widget.currentUser.birthday)))
                        .toString(),
                    style: kCardTextStyle,
                  ),
                  // onTap: (){
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return AlertDialog(
                  //         backgroundColor: kBackgroundColor,
                  //         title: const Text(
                  //           'Change Birthday',
                  //           style: kInstructionStyle2,
                  //         ),
                  //         content: SizedBox(
                  //           height: 130,
                  //           width: double.infinity,
                  //           child: CupertinoDatePicker(
                  //             mode: CupertinoDatePickerMode.date,
                  //             initialDateTime: DateTime.parse(currentUser.birthday),
                  //             maximumDate: DateTime.now(),
                  //             onDateTimeChanged: (DateTime value) {
                  //               newBirthday = DateFormat('yyyy-MM-dd')
                  //                   .format(value);
                  //             },
                  //           ),
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             child: const Text(
                  //               "Cancel",
                  //               style: kLinkStyle,
                  //             ),
                  //             onPressed: () {
                  //               Navigator.of(context).pop();
                  //             },
                  //           ),
                  //           TextButton(
                  //             child: const Text(
                  //               "Confirm",
                  //               style: kLinkStyle,
                  //             ),
                  //             onPressed: () async {
                  //               currentUser.birthday=newBirthday;
                  //               try{
                  //                 await _firestore
                  //                     .collection('users')
                  //                     .doc(currentUser.user?.uid)
                  //                     .set(
                  //                   {
                  //                     'birthday': newBirthday,
                  //                   },
                  //                   SetOptions(merge: true),);
                  //                 setState(() {
                  //                   currentUser.birthday;
                  //                 });
                  //                 snackBar(context, message: 'Birthday changed successfully.', color: kGreen);
                  //               }
                  //               catch(e){
                  //                 snackBar(context, message: e.toString(), color: kRed);
                  //               }
                  //               Navigator.of(context).pop();
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // },
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 1,
                  color: kTransparentColor3,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Additional Details',
                  style: kCardTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                for (var i in availableDetails.keys)
                  ListTile(
                    title: Text(
                      availableQuestions[i].toString(),
                      style: kTransparentStyle,
                    ),
                    subtitle: DropdownButton(
                      value: userDetails[i],
                      style: kCardTextStyle,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: kBackgroundColor,
                      items: availableDetails[i]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          userDetails[i] = value.toString();
                        });
                        try {
                          await _firestore
                              .collection('users')
                              .doc(currentUser.user.uid)
                              .collection('additionalDetails')
                              .doc('answers')
                              .set(
                            {
                              i: userDetails[i],
                            },
                            SetOptions(merge: true),
                          );
                        } catch (e) {
                          snackBar(context, message: e.toString(), color: kRed);
                        }
                      },
                    ),
                  ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
