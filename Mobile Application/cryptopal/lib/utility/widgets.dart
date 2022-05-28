import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'constants.dart';

Widget logoAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: kBackgroundColor,
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
            child: Image.asset('assets/images/CryptoPal-logo-white.png'),
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
  );
}

Widget glassCard(BuildContext context, Widget content) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: content,
      ),
    ).asGlass(
      clipBorderRadius: BorderRadius.circular(30),
      frosted: false,
    ),
  );
}

Widget openCloseAnimation(BuildContext context,
    {required Widget closeWidget, required Widget openWidget}) {
  return OpenContainer(
    closedColor: Colors.transparent,
    openColor: kBackgroundColor,
    closedElevation: 0,
    openElevation: 5.0,
    transitionType: ContainerTransitionType.fadeThrough,
    closedBuilder: (context, action) {
      return closeWidget;
    },
    openBuilder: (context, action) {
      return openWidget;
    },
  );
}
