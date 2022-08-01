import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);
  static const String id = 'TermsConditions';

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
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
                topBar(context, 'Terms & Conditions'),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 170,
                  child: Stack(
                    children: [
                      WebView(
                        initialUrl: 'https://cryptopal-e288a.web.app/TermsConditions',
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
