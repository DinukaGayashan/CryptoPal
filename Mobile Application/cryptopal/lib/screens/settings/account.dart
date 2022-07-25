import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/screens/settings/personal_details.dart';
import 'package:cryptopal/screens/settings/select_cryptocurrencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/user_account.dart';
import '../initialization/welcome.dart';

class Account extends StatefulWidget {
  const Account(this.currentUser, {Key? key}) : super(key: key);
  final UserAccount currentUser;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String newName;

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
                topBar(context, 'Account'),
                const SizedBox(
                  height: 20.0,
                ),
                ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text(
                      'Personal Details',
                      style: kCardTextStyle,
                    ),
                    onTap: (){
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                            return PersonalDetails(
                              currentUser,
                            );
                          })).then((_) {
                        setState(() {
                          currentUser.name;
                          currentUser.birthday;
                        });
                      });
                    }
                ),
                /*ListTile(
                  leading: const Icon(Icons.edit,),
                  title: const Text(
                    'Change Username',
                    style: kCardTextStyle,
                  ),
                  onTap: (){
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
                                hintText:  "Enter new username",
                                hintStyle: kTransparentStyle,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kAccentColor3),
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
                                try{
                                  currentUser.name=newName;
                                  await _firestore
                                      .collection('users')
                                      .doc(currentUser.user?.uid)
                                      .set(
                                    {
                                      'name': newName,
                                    },
                                    SetOptions(merge: true),);
                                  snackBar(context, message: 'Username changed successfully.', color: kGreen);
                                }
                                catch(e){
                                  snackBar(context, message: e.toString(), color: kRed);
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),*/
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text(
                    'Change Password',
                    style: kCardTextStyle,
                  ),
                  onTap: (){}
                ),
                ListTile(
                  leading: const Icon(Icons.currency_bitcoin),
                  title: const Text(
                    'Select Cryptocurrencies',
                    style: kCardTextStyle,
                  ),
                  onTap: (){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                          return const SelectCryptocurrencies();
                        }));
                  },
                ),
                const ListTile(),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(
                    'Sign Out',
                    style: kCardTextStyle,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: kBackgroundColor,
                          title: const Text(
                            'Confirm Sign Out',
                            style: kInstructionStyle2,
                          ),
                          content: const Text(
                            "Do you want to sign out?",
                            style: kInstructionStyle,
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                "No",
                                style: kLinkStyle,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                "Yes",
                                style: kLinkStyle,
                              ),
                              onPressed: () async {
                                _auth.signOut();
                                SharedPreferences.getInstance().then(
                                      (prefs) {
                                    prefs.setBool("remember_me", false);
                                  },
                                );
                                Navigator.of(context)
                                    .pushNamedAndRemoveUntil(Welcome.id, (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.remove_circle_outline),
                    title: const Text(
                      'Delete Account',
                      style: kCardTextStyle4,
                    ),
                    iconColor: kRed,
                    onTap: (){}
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
