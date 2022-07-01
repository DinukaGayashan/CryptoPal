import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';

import 'package:cryptopal/screens/initialization/welcome.dart';

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
      backgroundColor: Colors.transparent,
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
                glassCard(context,
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: currentUser.name + '\n',
                        style: kCardTitleStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: currentUser.user?.email.toString(),
                            style: kTransparentStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ListTile(
                  leading: const Icon(Icons.drive_file_rename_outline),
                  title: const Text(
                    'Change Username',
                    style: kCardTextStyle,
                  ),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            'Change Username\n',
                            style: kInstructionStyle2,
                          ),
                          content: Column(
                            children: [
                              const Text(
                                "Enter new username\n",
                                style: kInstructionStyle,
                              ),
                              SizedBox(
                                width: 200,
                                height: 35,
                                child: CupertinoTextField(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  textAlign: TextAlign.center,
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
                            ],
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
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(
                    'Sign Out',
                    style: kCardTextStyle,
                  ),
                  textColor: kRed,
                  iconColor: kRed,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            'Confirm Sign Out\n',
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

              ],
            ),

          ),
        ),
      ),
    );
  }
}
