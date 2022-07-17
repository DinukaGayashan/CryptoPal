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
      backgroundColor: kBaseColor1,
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
                    height: 20.0,
                  ),
                  for (var news in widget.newsList)
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NewsDisplay(news);
                        }));
                      },
                    ),
                  const SizedBox(
                    height: 30,
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
