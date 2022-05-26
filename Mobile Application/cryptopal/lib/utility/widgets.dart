import 'package:flutter/material.dart';
import 'constants.dart';

Widget logoAppBar (BuildContext context){
  return SafeArea(
    child: AppBar(
      backgroundColor: kAccentColor1,
      elevation: 0.0,
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25.0,
              child: Image.asset('assets/images/CryptoPal-logo-black.png'),
            ),
          ),
          const Hero(
            tag: 'name',
            child: Text(
              "CryptoPal",
              style: kTitleStyle,
            ),
          ),
        ],
      ),
    ),
  );
}