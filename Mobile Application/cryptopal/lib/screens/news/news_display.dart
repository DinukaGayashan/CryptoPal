import 'package:flutter/material.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDisplay extends StatefulWidget {
  const NewsDisplay(this.news, {Key? key}) : super(key: key);
  final News news;

  @override
  State<NewsDisplay> createState() => _NewsDisplayState();
}

class _NewsDisplayState extends State<NewsDisplay> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            Column(
              children: <Widget>[
                topBar(context, 'News on ' + widget.news.source.toString()),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: LinearProgressIndicator(
                    value: progress,
                    color: kAccentColor1,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    child: WebView(
                      initialUrl: widget.news.link,
                      javascriptMode: JavascriptMode.unrestricted,
                      onProgress: (progress) =>
                          setState(() => this.progress = progress / 100),
                      onPageFinished: (progress) =>
                          setState(() => this.progress = 0),
                    ),
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
