import 'package:flutter/material.dart';

const List<String> cryptocurrencyNames = <String>[
  "Bitcoin",
  "Ethereum",
  "Litecoin",
  "Ripple",
  "Dogecoin"
];

const List<String> cryptocurrencies = <String>[
  "BTC",
  "ETH",
  "LTC",
  "XRP",
  "DOGE"
];

const kBaseColor1 = Color(0xff000000);
const kBaseColor2 = Color(0xffeeeeee);
const kBackgroundColor = Color(0xff121212);
const kAccentColor1 = Color(0xff14efbb);
const kAccentColor2 = Color(0xffffd369);
const kAccentColor3 = Color(0xff1d708f);
//const kAccentColor4 = Color(0xff4C4637);
const kTransparentColor = Color(0x2214efbb);
const kTransparentColor2 = Color(0xaa14efbb);
const kRed = Color(0xffea4f30);
const kGreen = Color(0xff1fba72);
const kYellow = Color(0xfff1ae2d);
const kBlue = Color(0xff008ff7);

const kAnimationTime = 1000;

DateTime kMinDayInGraph=DateTime.now().subtract(const Duration(days: 60));

const TextStyle kMainTitleStyle = TextStyle(
  color: kBaseColor2,
  fontFamily: 'Tenorite',
  fontSize: 50,
);

const TextStyle kTitleStyle = TextStyle(
  color: kBaseColor2,
  fontFamily: 'Tenorite',
  fontSize: 30,
);

const TextStyle kBlackTitleStyle = TextStyle(
  color: kBaseColor1,
  fontFamily: 'Tenorite',
  fontSize: 30,
);

const TextStyle kSubjectStyle = TextStyle(
  fontSize: 25,
  fontFamily: 'Bierstadt',
  color: kAccentColor1,
);

const TextStyle kSubSubjectStyle = TextStyle(
  fontSize: 25,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kInstructionStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kInstructionStyle2 = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kInstructionStyle3 = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor1,
);

const TextStyle kLinkStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kAccentColor3,
);

const TextStyle kHintStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kAccentColor3,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor1,
);

const TextStyle kDetailsStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kAccentColor1,
);

const TextStyle kCardTitleStyle = TextStyle(
  fontSize: 28,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kCardTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kCardTextStyle2 = TextStyle(
  fontSize: 20,
  fontFamily: 'Bierstadt',
  color: kAccentColor1,
);

const TextStyle kCardTextStyle3 = TextStyle(
  fontSize: 50,
  fontFamily: 'Bierstadt',
  color: kAccentColor1,
);

const TextStyle kCardSmallTextStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kCardNumberStyle = TextStyle(
  fontSize: 50,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);

const TextStyle kSnackBarStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
);
