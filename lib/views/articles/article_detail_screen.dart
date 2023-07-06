import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../view-models/article_view_model.dart';

class ArticleDetailScreen extends StatefulWidget {
  final int index;
  const ArticleDetailScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    final article = context.read<ArticleViewModel>().articles[widget.index];
    controller.loadRequest(Uri.parse(article.url));
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
