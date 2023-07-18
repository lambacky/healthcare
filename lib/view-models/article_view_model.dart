import 'package:flutter/material.dart';
import 'package:healthcare/models/article.dart';
import 'package:healthcare/services/article_api_service.dart';

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  bool _loading = false;
  bool get loading => _loading;
  Future<void> fetchArticle() async {
    _loading = true;
    try {
      _articles = await ArticleApiService().getArticle();
    } catch (e) {
      print(e);
    }
    _loading = false;
    notifyListeners();
  }
}
