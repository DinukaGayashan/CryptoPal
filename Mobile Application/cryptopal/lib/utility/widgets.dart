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
      color: Colors.white12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: content,
      ),
    )/*.asGlass(
      clipBorderRadius: BorderRadius.circular(30),
      frosted: false,
      //tileMode:TileMode.clamp,
      //tintColor: kBaseColor1,
    ),*/
  );
}

Widget openCloseAnimation(BuildContext context,
    {required Widget closeWidget, required Widget openWidget}) {
  return OpenContainer(
    closedColor: Colors.transparent,
    openColor: Colors.transparent,
    closedElevation: 0,
    openElevation: 5.0,
    transitionType: ContainerTransitionType.fade,
    closedBuilder: (context, action) {
        return closeWidget;
    },
    openBuilder: (context, action) {
        return openWidget;
    },
  );
}

Widget topBar(BuildContext context, String title){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: 30,
        child: IconButton(
          enableFeedback: true,
            padding: const EdgeInsets.only(left: 15,right: 20,top:15,bottom: 20),
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(BuildContext context,{required message, required color}){
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