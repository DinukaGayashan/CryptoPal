import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptopal/utility/news_data.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'news_display.dart';

class NewsListDisplay extends StatefulWidget {
  const NewsListDisplay(this.newsList, {Key? key}) : super(key: key);
  final List<News> newsList;

  @override
  State<NewsListDisplay> createState() => _NewsListDisplayState();
}

class _NewsListDisplayState extends State<NewsListDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(
            context,
            CupertinoScrollbar(
              child: ListView(
                children: <Widget>[
                  topBar(context, 'News'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  for (var news in widget.newsList)
                    GestureDetector(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 96,
                            child: Image.network(
                              news.imageUrl.toString(),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.source.toString(),
                                  style: kTransparentSmallStyle,
                                ),
                                Text(
                                  news.title.toString(),
                                  style: kCardSmallTextStyle,
                                ),
                                Text(
                                  news.date.toString().split('T')[0],
                                  style: kTransparentSmallStyle,
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NewsDisplay(news);
                        }));
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
