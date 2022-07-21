import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/screens/dashboard/select_cryptocurrencies.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';

import 'package:cryptopal/screens/initialization/welcome.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'about_app.dart';
import 'help.dart';

class Account extends StatefulWidget {
  const Account(this.currentUser, {Key? key}) : super(key: key);
  final UserAccount currentUser;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String newName,joinedDate='';
  late int profileLevel;
  late Color kUserColor;
  late GlobalKey userCardKey;

  @override
  Widget build(BuildContext context) {

    final dates=currentUser.history.keys.toList();
    dates.sort();
    joinedDate=dates.first;
    int userGroup=currentUser.score~/100;
    int userLevelInGroup=currentUser.score%(userGroup==0?100:userGroup*100);
    try{
      kUserColor=Color.alphaBlend(kUserColorMap[userGroup+1].withAlpha(userLevelInGroup), kUserColorMap[userGroup].withAlpha(255-userLevelInGroup));
    }catch(e){
      kUserColor=topLevelUserColor;
    }

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
                WidgetToImage(
                    builder: (key){
                      userCardKey=key;
                      return Card(
                        color: kUserColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                        child: SizedBox(
                          height: 220,
                          child: Stack(
                            children: [
                              SizedBox(
                                width:double.infinity,
                                child: RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                    text: '\n',
                                    style: const TextStyle(
                                      fontSize:85,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: kUserScoreDisplay(currentUser.score),
                                        style: const TextStyle(
                                          fontSize:160,
                                          fontFamily: 'Bierstadt',
                                          color: kTransparentColor5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '${currentUser.name}\n',
                                    style: kCardTitleStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: currentUser.user?.email.toString(),
                                        style: kCardSmallTextStyle,
                                      ),
                                      TextSpan(
                                        text:'\nJoined $joinedDate',
                                        style: kTransparentSmallStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    const SizedBox(width: 10,),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 15.0,
                                      child: Image.asset(
                                          'assets/images/CryptoPal-logo-black.png'),
                                    ),
                                    const Text(
                                        'CryptoPal',
                                        style: kSmallBlackTitleStyle,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).asGlass(
                        clipBorderRadius: BorderRadius.circular(30),
                        frosted: false,
                        tintColor: kUserColor,
                      );
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // IconButton(
                    //   tooltip:'Share User Card',
                    //   icon: const Icon(
                    //     Icons.share,
                    //     size: 20,
                    //     color: kTransparentColor3,
                    //   ),
                    //   onPressed: (){}
                    // ),
                    /*IconButton(
                      tooltip:'Download User Card',
                      icon: const Icon(
                        Icons.download,
                        size: 20,
                        color: kTransparentColor3,
                      ),
                      onPressed: () async {
                        try{
                          RenderRepaintBoundary boundary= userCardKey.currentContext?.findRenderObject()  as RenderRepaintBoundary;
                          final image=await boundary.toImage(pixelRatio:10);
                          final bytes=await image.toByteData(format: ui.ImageByteFormat.png);
                          final pngBytes=bytes?.buffer.asUint8List();

                          final String dir = (await getApplicationDocumentsDirectory()).path;
                          final String fullPath = '$dir/CryptoPal_${currentUser.name}_User_Card@${DateTime
                              .now()}.png';
                          File capturedFile = File(fullPath);
                          await capturedFile.writeAsBytes(pngBytes!);
                          await GallerySaver.saveImage(capturedFile.path);

                          snackBar(context, message: 'User Card saved to Gallery.', color: kGreen);
                        }catch(e){
                          snackBar(context, message: e.toString(), color: kRed);
                        }
                      },
                    ),*/
                    IconButton(
                      tooltip:'Share User Card',
                      icon: const Icon(
                        Icons.share,
                        size: 20,
                        color: kTransparentColor3,
                      ),
                      onPressed: () async {
                        RenderRepaintBoundary boundary= userCardKey.currentContext?.findRenderObject()  as RenderRepaintBoundary;
                        final image=await boundary.toImage(pixelRatio:3);
                        final bytes=await image.toByteData(format: ui.ImageByteFormat.png);
                        final pngBytes=bytes?.buffer.asUint8List();

                        final String dir = (await getTemporaryDirectory()).path;
                        final String fullPath = '$dir/CryptoPal_${currentUser.name}_User_Card@${DateTime
                            .now()}.png';
                        File capturedFile = File(fullPath);
                        await capturedFile.writeAsBytes(pngBytes!);
                        await Share.shareFiles([fullPath],text:'CryptoPal User Card of ${currentUser.name} @${DateTime
                            .now()}');
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_rounded),
                  title: const Text(
                    'Account Settings',
                    style: kCardTextStyle,
                  ),
                  onTap: () {

                  },
                ),
                ListTile(
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
                ListTile(
                  leading: const Icon(Icons.format_list_bulleted,),
                  title: const Text(
                    'Fill User Form',
                    style: kCardTextStyle,
                  ),
                  onTap: (){
                    snackBar(context, message: 'Not Yet Implemented', color: kYellow);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text(
                    'Help',
                    style: kCardTextStyle,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                          return const Help();
                        }));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.touch_app),
                  title: const Text(
                    'About App',
                    style: kCardTextStyle,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                          return const AboutApp();
                        }));
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

                const SizedBox(
                  height: 30,
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class WidgetToImage extends StatefulWidget {
  final Function(GlobalKey key) builder;

  const WidgetToImage({required this.builder, Key? key}) : super(key: key);

  @override
  State<WidgetToImage> createState() => _WidgetToImageState();
}

class _WidgetToImageState extends State<WidgetToImage> {
  final globalKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}
