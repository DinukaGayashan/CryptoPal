import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cryptopal_web/constants.dart';

// Widget glassCard(BuildContext context, Widget content) {
//   return Padding(
//     padding: const EdgeInsets.all(5.0),
//     child: Container(
//       decoration: BoxDecoration(
//         color: kCardColor,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: content,
//       ),
//     ).asGlass(
//       clipBorderRadius: BorderRadius.circular(30),
//       tintColor: kTransparentColor4,
//       frosted: false,
//     ),
//   );
// }

Widget background(BuildContext context, Widget content) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(kBackgroundColor, BlendMode.darken)),
      //color: kBackgroundColor,
    ),
    child: content,
  );
}

Widget downloadButton() {
  return SizedBox(
    width: 220,
    child: InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: kTransparentColor1,
          ),
        ),
        width: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.android,
                color: Color(0xff3ddc84),
                size: 30,
              ),
              Text(
                'Download APK',
                style: TextStyle(
                  color: kBaseColor2,
                  fontFamily: 'Tenorite',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        await launch(
            'https://firebasestorage.googleapis.com/v0/b/cryptopal-e288a.appspot.com/o/CryptoPal%20app-release%2Fapp-release.apk?alt=media&token=7f1f32c9-709b-4664-a0c3-3a905b2cdd64');
      },
    ),
  );
}

// Widget topBar(BuildContext context, String title) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: <Widget>[
//       SizedBox(
//         width: 30,
//         child: IconButton(
//           enableFeedback: true,
//           padding:
//           const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
//           icon: const Icon(Icons.arrow_back_ios),
//           color: kBaseColor2,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       Text(
//         title,
//         style: kTopBarStyle,
//       ),
//       const SizedBox(
//         width: 30.0,
//       ),
//     ],
//   );
// }

// ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
//     BuildContext context,
//     {required message,
//       required color}) {
//   return ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(5))),
//       behavior: SnackBarBehavior.floating,
//       content: Text(
//         message,
//         style: kSnackBarStyle,
//         textAlign: TextAlign.center,
//       ),
//       backgroundColor: color,
//     ),
//   );
// }
