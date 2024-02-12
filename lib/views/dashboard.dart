import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news_app/views/newsDetails.dart';

class NewsDashboard extends StatefulWidget {
  @override
  _NewsDashboardState createState() => _NewsDashboardState();
}

class _NewsDashboardState extends State<NewsDashboard> {
  List<Map<String, dynamic>> newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  static const searchWord = 'covid';

  Future<void> fetchArticles() async {
  final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=${searchWord}&from=2024-02-2&sortBy=relevancy&apiKey=1246daf94c8a4d459ab5eb2d88a31833'));

  if (response.statusCode == 200) {
    // Assuming the JSON structure is something like { "articles": [ { "title": "...", "description": "..." }, ... ] }
    Map<String, dynamic> responseBody = json.decode(response.body);
    List<dynamic> articlesJson = responseBody['articles']; // Access the 'articles' key

       setState(() {
      newsArticles = articlesJson.map((article) {
        return {
          'title': article['title'],
          'description': article['description'],
          'urlToImage': article['urlToImage'],
          'publishedAt': article['publishedAt'].substring(0, 10),
          'url': article['url'],
          'source': '${(article['source'] as Map<String, dynamic>)['name'] ?? 'Unknown'}',
          'content':article['content']
          // Include other fields as needed
        };
      }).toList();
    });
  } else {
    // Handle the error; maybe show an alert or a placeholder
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(article['title']),
              subtitle: Text(article['description'] ?? 'No Description Available'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetails(article: article),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
