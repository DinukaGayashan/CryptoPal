import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'constants.dart';

Widget glassCard(BuildContext context, Widget content) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: content,
      ),
    ).asGlass(
      clipBorderRadius: BorderRadius.circular(30),
      tintColor: kTransparentColor4,
      frosted: false,
    ),
  );
}

Widget glassBackground(BuildContext context, Widget content) {
  return Container(
    decoration: BoxDecoration(
      color: kBackgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 21.0),
      child: content,
    ),
  );
}

Widget topBar(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: 30,
        child: IconButton(
          enableFeedback: true,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
          icon: const Icon(Icons.arrow_back_ios),
          color: kBaseColor2,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Text(
        title,
        style: kTopBarStyle,
      ),
      const SizedBox(
        width: 30.0,
      ),
    ],
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    BuildContext context,
    {required message,
    required color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: kSnackBarStyle,
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ),
  );
}
