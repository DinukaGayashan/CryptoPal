import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> cryptocurrencyNames = <String>[
  "Bitcoin (BTC)", "Ethereum (ETH)", "Litecoin (LTC)", "Ripple (XRP)", "Dogecoin (DOGE)"
];

const List<String> cryptocurrencies = <String>[
  "BTC", "ETH", "LTC", "XRP", "DOGE"
];

const kBaseColor1=Color(0xff000000);
const kBaseColor2=Color(0xffffffff);
const kAccentColor1=Color(0xffffe699);
const kAccentColor2=Color(0xFF0c4d5f);
const kAccentColor3=Color(0xff4C4637);
const kTransparentColor=Color(0xcc4C4637);

const TextStyle kMainTitleStyle=TextStyle(
  color: kBaseColor1,
  fontFamily: 'Tenorite',
  fontSize: 50,
);

const TextStyle kTitleStyle=TextStyle(
  color: kBaseColor1,
  fontFamily: 'Tenorite',
  fontSize: 30,
);

const TextStyle kSubjectStyle = TextStyle(
  fontSize: 25,
  fontFamily: 'Bierstadt',
  color: kAccentColor2,
);

const TextStyle kSubSubjectStyle = TextStyle(
  fontSize: 25,
  fontFamily: 'Bierstadt',
  color: kBaseColor1,
  fontWeight: FontWeight.bold,
);

const TextStyle kInstructionStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kBaseColor1,
);

const TextStyle kInstructionStyle2 = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor1,
);

const TextStyle kHintStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kAccentColor3,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
  fontWeight: FontWeight.bold,
);

const TextStyle kDetailsStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kAccentColor3,
);

