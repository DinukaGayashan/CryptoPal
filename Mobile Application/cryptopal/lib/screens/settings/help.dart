import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
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
                topBar(context, 'Help'),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Stack(
                    children: [
                      WebView(
                        initialUrl: 'https://cryptopal-e288a.web.app/Help',
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
