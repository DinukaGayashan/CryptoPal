import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);
  static const String id = 'PrivacyPolicy';

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            Column(
              children: <Widget>[
                topBar(context, 'Privacy Policy'),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 170,
                  child: Stack(
                    children: [
                      WebView(
                        initialUrl: 'https://cryptopal-e288a.web.app/PrivacyPolicy',
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: (progress) =>
                            setState(() => loading = false),
                      ),
                      loading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: kAccentColor1,
                        ),
                      )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
