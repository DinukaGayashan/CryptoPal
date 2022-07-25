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
  late String oldPassword,newPassword1,newPassword2;

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
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text(
                    'Change Password',
                    style: kCardTextStyle,
                  ),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: kBackgroundColor,
                          title: const Text(
                            'Change Password',
                            style: kInstructionStyle2,
                          ),
                          content: Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            height: 150,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  width: 200,
                                  height: 35,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter current password",
                                      hintStyle: kTransparentStyle,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kAccentColor3),
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    style: kCardTextStyle,
                                    cursorHeight: 20,
                                    cursorColor: kBaseColor2,
                                    autofocus: true,
                                    onChanged: (value) {
                                      oldPassword=value;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                SizedBox(
                                  width: 200,
                                  height: 35,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter new password",
                                      hintStyle: kTransparentStyle,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kAccentColor3),
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    style: kCardTextStyle,
                                    cursorHeight: 20,
                                    cursorColor: kBaseColor2,
                                    autofocus: true,
                                    onChanged: (value) {
                                      newPassword1=value;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  width: 200,
                                  height: 35,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter new password",
                                      hintStyle: kTransparentStyle,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kAccentColor3),
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    style: kCardTextStyle,
                                    cursorHeight: 20,
                                    cursorColor: kBaseColor2,
                                    autofocus: true,
                                    onChanged: (value) {
                                      newPassword2=value;
                                    },
                                  ),
                                ),
                              ],
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
                                  final authCredentials=EmailAuthProvider.credential(email: currentUser.user.email.toString(), password: oldPassword);
                                  final passwordCheck=await currentUser.user.reauthenticateWithCredential(authCredentials);
                                  if(passwordCheck.user!=null){
                                    try{
                                      if(newPassword1==newPassword2){
                                        try{
                                          currentUser.user.updatePassword(newPassword1);
                                          snackBar(context, message: 'Password changed successfully.', color: kGreen);
                                          Navigator.of(context).pop();
                                        }catch(e){
                                          snackBar(context, message: e.toString(), color: kRed);
                                        }
                                      }
                                      else{
                                        snackBar(context, message: 'Entered new passwords are not matching.', color: kRed);
                                      }
                                    }catch(e){
                                      snackBar(context, message: e.toString(), color: kRed);
                                    }
                                  }
                                }catch(e){
                                  snackBar(context, message: 'Entered password is not correct.', color: kRed);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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
