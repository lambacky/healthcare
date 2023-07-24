import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../view-models/article_view_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final int index;
  const ArticleDetailScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articleViewModel = context.read<ArticleViewModel>();
    articleViewModel.initializeWebView(index);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Health Article"),
      ),
      body: WebViewWidget(
        controller: articleViewModel.controller,
      ),
    );
  }
}
