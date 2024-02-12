import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatelessWidget {
  final Map<String, dynamic> article;
  

  const NewsDetails({required this.article});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.only(bottom:20.0, right: 10.0),
            child: Text(
              article['title'] ?? 'No Title',
              style: Theme.of(context).textTheme.titleLarge,
            )
            ),


            if (article['urlToImage'] != null)
              Image.network(article['urlToImage']),
            SizedBox(height: 10),
            Text(
              'Source: ${article['source'] ?? 'Unknown'}             ${article['publishedAt'] ?? 'No Date'}',
              style:
               Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(height: 5),
            SizedBox(height: 10),
            
            SizedBox(height: 10),
            Text(
              article['description'] ?? 'No Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),
            Text(
              '${article['content'] ?? 'No Content'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            article['url'] != null
                ? InkWell(
                    onTap: () => _launchURL(article['url']),
                    child: const Text(
                      'Read Full Article',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
