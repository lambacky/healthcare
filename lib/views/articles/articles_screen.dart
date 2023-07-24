import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../components/article_card.dart';
import '../../view-models/article_view_model.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ArticleViewModel>().fetchArticle();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Health Articles"),
      ),
      body: Consumer<ArticleViewModel>(
          builder: (context, articleViewModel, child) {
        if (articleViewModel.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (articleViewModel.articles.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: articleViewModel.articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(index: index);
              },
            );
          }
          return Center(
              child: Text(
            'Data loading failed. Please check your network',
            style: TextStyle(color: Colors.black.withOpacity(0.3)),
          ));
        }
      }),
    );
  }
}
