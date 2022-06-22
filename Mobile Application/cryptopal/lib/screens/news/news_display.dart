import 'package:flutter/material.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

class NewsDisplay extends StatefulWidget {
  const NewsDisplay(this.newsList, {Key? key}) : super(key: key);
  final List<News> newsList;

  @override
  State<NewsDisplay> createState() => _NewsDisplayState();
}

class _NewsDisplayState extends State<NewsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Statistics'),
                const SizedBox(
                  height: 10.0,
                ),
                for(var news in widget.newsList)
                  glassCard(context,
                    Text(news.title.toString()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

