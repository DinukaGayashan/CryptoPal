import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';


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
  late GlobalKey key1;


  @override
  Widget build(BuildContext context) {

    final dates=currentUser.history.keys.toList();
    dates.sort();
    joinedDate=dates.first;

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
                WidgetToImage(
                    builder: (key){
                      key1=key;
                      return Card(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(00),
                          child: SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      '65',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize:300,
                                        fontFamily: 'Bierstadt',
                                        color: kTransparentColor5,
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: currentUser.name + '\n',
                                      style: kCardTitleStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: currentUser.user?.email.toString(),
                                          style: kCardTextStyle,
                                        ),
                                        TextSpan(
                                          text:'\nJoined '+joinedDate,
                                          style: kTransparentStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).asGlass(
                        clipBorderRadius: BorderRadius.circular(30),
                        frosted: true,
                        //tileMode:TileMode.clamp,
                        //tintColor: kBaseColor1,
                      );
                    }
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      tooltip:'Share User Card',
                      icon: const Icon(
                        Icons.share,
                        size: 20,
                        color: kTransparentColor3,
                      ),
                      onPressed: () async {
                        RenderRepaintBoundary boundary= key1.currentContext?.findRenderObject()  as RenderRepaintBoundary;
                        final image=await boundary.toImage(pixelRatio:3);
                        final bytes=await image.toByteData(format: ui.ImageByteFormat.png);
                        final pngBytes=bytes?.buffer.asUint8List();

                        final String dir = (await getTemporaryDirectory()).path;
                        final String fullPath = '$dir/CryptoPal_${currentUser.name}_User_Card@${DateTime
                            .now()}.png';
                        File capturedFile = File(fullPath);
                        await capturedFile.writeAsBytes(pngBytes!);

                        await GallerySaver.saveImage(capturedFile.path);
                        await Share.share('CryptoPal User Card of ${currentUser.name} @${DateTime
                            .now()}');
                      },
                    ),
                    IconButton(
                      tooltip:'Change Username',
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: kTransparentColor3,
                      ),
                      onPressed: () {
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
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text(
                    'Fill Profile Details',
                    style: kCardTextStyle,
                  ),
                  onTap: (){

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
