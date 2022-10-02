import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cryptopal/auth/secrets.dart';

Future<List<News>> getNewsData(bool x) async {
  late List<News> news = [];

  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=cryptocurrency&apiKey=$NewsAPIAPIKey'));

  final numberOfNews = jsonDecode(response.body)['articles'].length;

  for (int i = 0; i < numberOfNews; i++) {
    try {
      news.add(News.fromJson(jsonDecode(response.body), i));
    } catch (e) {
      rethrow;
    }
  }
  news.sort((a, b) => b.date.toString().compareTo(a.date.toString()));
  return news;
}

class News {
  late String? title;
  late String? link;
  late String? description;
  late String? content;
  late String? date;
  late String? imageUrl;
  late String? source;
  late String? author;

  News(
      {this.title,
      this.link,
      this.description,
      this.content,
      this.date,
      this.imageUrl,
      this.source,
      this.author});

  factory News.fromJson(Map<String, dynamic> json, int index) {
    return News(
      title: json['articles'][index]['title'],
      link: json['articles'][index]['url'],
      description: json['articles'][index]['description'],
      content: json['articles'][index]['content'],
      date: json['articles'][index]['publishedAt'],
      imageUrl: json['articles'][index]['urlToImage'],
      source: json['articles'][index]['source']['name'],
      author: json['articles'][index]['author'],
    );
  }
}
