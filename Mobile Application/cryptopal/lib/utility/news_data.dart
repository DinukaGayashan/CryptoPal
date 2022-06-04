import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cryptopal/auth/secrets.dart';

Future<List<News>> getNewsData() async {
  const int numberOfNews = 10;
  late List<News> news = [];

  for (int i = 0; i < numberOfNews; i++) {
    news.add(await getNews(i));
  }
  return news;
}

Future<News> getNews(int index) async {
  final response = await http.get(Uri.parse(
      'https://newsdata.io/api/1/news?apikey=' +
          NewsDataAPIKey +
          '&category=business&q=cryptocurrency&language=en'));

  try {
    return News.fromJson(jsonDecode(response.body), index);
  } catch (e) {
    print(e);
    throw Exception(e);
  }
}

class News {
  late String? title;
  late String? link;
  late String? description;
  late String? content;
  late String? date;
  late String? imageUrl;
  late String? source;

  News(
      {this.title,
      this.link,
      this.description,
      this.content,
      this.date,
      this.imageUrl,
      this.source});

  factory News.fromJson(Map<String, dynamic> json, int index) {
    return News(
      title: json['results'][index]['title'],
      link: json['results'][index]['link'],
      description: json['results'][index]['description'],
      content: json['results'][index]['content'],
      date: json['results'][index]['pubDate'],
      imageUrl: json['results'][index]['image_url'],
      source: json['results'][index]['source_id'],
    );
  }
}
