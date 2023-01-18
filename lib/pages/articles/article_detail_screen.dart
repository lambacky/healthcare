import '/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    controller.loadRequest(Uri.parse(widget.article.url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Health Article"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
