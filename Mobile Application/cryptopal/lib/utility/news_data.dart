import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cryptopal/auth/secrets.dart';

Future<News> getNewsData () async {
  final response=await http.get(Uri.parse('https://newsdata.io/api/1/news?apikey='+NewsDataAPIKey+'&category=business&q=cryptocurrency&language=en'));
  final int numberOfNews=10;
  late Future<News> news;

  try{
    //print(response.body);
    return News.fromJson(jsonDecode(response.body));
  }
  catch(e){
    print(e);
    throw Exception(e);
  }
}

class News{
  late String title;
      late String link;
      late String description;
      late String content;
      late String date;
      late String imageUrl;
      late String source;

      News({required this.title,required this.link,required this.description,required this.content,required this.date,required this.imageUrl,required this.source});

      factory News.fromJson(Map<String, dynamic> json){
        print(json['results'][0]['title']);
        return News(
          title: json['results'][0]['title'],
          link: json['results'][0]['link'],
          description: json['results'][0]['description'],
          content: json['results'][0]['content'],
          date: json['results'][0]['pubDate'],
          imageUrl: json['results'][0]['image_url'],
          source: json['results'][0]['source_id'],
        );
      }
}