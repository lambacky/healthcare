import 'package:flutter/material.dart';
import 'package:healthcare/models/article.dart';
import 'package:healthcare/services/article_api_service.dart';

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;

  Future<void> fetchArticle() async {
    try {
      _articles = await ArticleApiService().getArticle();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
