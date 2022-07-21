import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';

const String description="CryptoPal is an advisory platform for cryptocurrency investments that only focused on educational purposes. Please do not use this application as a advisor for financial investment purposes.";
const String version='Version 0.8';

const kBaseColor1 = Color(0xff000000);
const kBaseColor2 = Color(0xffeeeeee);
const kBackgroundColor = Color(0xee121212);
const kCardColor = Color(0x99202020);
const kAccentColor1 = Color(0xff14efbb);
const kAccentColor2 = Color(0xffffd369);
const kAccentColor3 = Color(0xff1d708f);
const kTransparentColor1 = Color(0x2214efbb);
const kTransparentColor2 = Color(0x8814efbb);
const kTransparentColor3 = Color(0xaaeeeeee);
const kTransparentColor4 = Color(0xaa121212);
const kTransparentColor5 = Color(0x33121212);
const kTransparentColor6 = Color(0x33000000);
const kTransparentColor7 = Color(0x66151515);
const kTransparentColor8 = Color(0x11101010);
const kRed = Color(0xffea4f30);
const kGreen = Color(0xff1fba72);
const kYellow = Color(0xfff1ae2d);
const kBlue = Color(0xff008ff7);
const kGraphColor1= Color(0xff1bbfd0);
const kGraphColor2= Color(0xffdd636b);
const List<Color> kUserColorMap=[Color(0xff121212),Color(0xff607d8b),Color(0xff9e9e9e),Color(0xff795548),
  Color(0xffff5722),Color(0xffff9800),Color(0xffffc107),Color(0xffcddc39),Color(0xff8bc34a),Color(0xff4caf50),
  Color(0xff009688),Color(0xff00bcd4),Color(0xff03a9f4),Color(0xff2196f3),Color(0xff00bcd4),Color(0xff3f51b5),
  Color(0xff673ab7),Color(0xff9c27b0),Color(0xffe91e63),Color(0xfff44336)];
const Color topLevelUserColor=Color(0xffff1144);

DateTime kMinDayInGraph = DateTime.now().subtract(const Duration(days: 60));
DateTime kMinDayInForecastGraph = DateTime.now().subtract(const Duration(days: 40));
DateTime kMinDayInExtendedGraph =
    DateTime.now().subtract(const Duration(days: 100));
DateTime kMinDayInSmallGraph =
DateTime.now().subtract(const Duration(days: 10));

final kDashboardPriceDisplay = createDisplay(length: 7);
final kCurrencyPriceDisplay = createDisplay(length: 10);
final kUserScoreDisplay = createDisplay(length:4);

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

const TextStyle kSmallTitleStyle = TextStyle(
  color: kBaseColor2,
  fontFamily: 'Tenorite',
  fontSize: 20,
);

const TextStyle kSmallBlackTitleStyle = TextStyle(
  color: kBaseColor1,
  fontFamily: 'Tenorite',
  fontSize: 20,
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

const TextStyle kTopBarStyle = TextStyle(
  fontSize: 24,
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

const TextStyle kCardLargeTextStyle = TextStyle(
  fontSize: 23,
  fontFamily: 'Bierstadt',
  color: kBaseColor2,
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

const TextStyle kTransparentStyle = TextStyle(
  fontSize: 15,
  fontFamily: 'Bierstadt',
  color: kTransparentColor3,
);

const TextStyle kTransparentSmallStyle = TextStyle(
  fontSize: 12,
  fontFamily: 'Bierstadt',
  color: kTransparentColor3,
);