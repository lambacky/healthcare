import '../../services/article_api_service.dart';
import 'package:flutter/material.dart';
import '../../components/article_card.dart';
import '/models/article_model.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  ArticleApiService client = ArticleApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Health Articles"),
      ),
      body: FutureBuilder(
        future: client.getArticle(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            List<Article>? articles = snapshot.data;
            if (articles!.isNotEmpty) {
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) =>
                    ArticleCard(article: articles[index]),
              );
            }
            return Center(
                child: Text(
              'Data loading failed. Please check your network',
              style: TextStyle(color: Colors.black.withOpacity(0.3)),
            ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
