import 'package:flutter/material.dart';
import 'package:healthcare/models/article.dart';
import 'package:healthcare/services/article_api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleViewModel extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> get articles => _articles;
  bool _loading = false;
  bool get loading => _loading;
  late WebViewController _controller;
  WebViewController get controller => _controller;

  Future<void> fetchArticle() async {
    _loading = true;
    _articles = await ArticleApiService().getArticle();
    _loading = false;
    notifyListeners();
  }

  Future<void> initializeWebView(int index) async {
    _controller = WebViewController();
    final article = _articles[index];
    await controller.loadRequest(Uri.parse(article.url));
    notifyListeners();
  }
}
