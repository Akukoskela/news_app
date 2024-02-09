import 'package:flutter/material.dart';

class NewsDashboard extends StatelessWidget {
  final List<Map<String, String>> newsArticles = [
    {
      'title': 'Breaking News: Flutter 3.0 Released',
      'description': 'Flutter 3.0 comes with significant updates, including null safety features, web support improvements, and more.',
    },
    {
      'title': 'Tech Update: AI Revolutionizing Industries',
      'description': 'From healthcare to finance, Artificial Intelligence is transforming every sector with its innovative solutions.',
    },
    {
      'title': 'Global Event: Climate Change Conference 2023',
      'description': 'Experts from around the world gather to discuss climate change impacts and sustainable solutions for the future.',
    },
    // Add more mock news articles here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('moi'),
      ),
      body: ListView.builder(
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(article['title']!),
              subtitle: Text(article['description']!),
              onTap: () {
                // Handle the tap event, e.g., navigate to a detailed news view
                print('Tapped on ${article['title']}');
              },
            ),
          );
        },
      ),
    );
  }
}
