import 'dart:convert';

import '/models/article.dart';
import 'package:http/http.dart';

class ArticleApiService {
  final _endPointUrl =
      "https://newsapi.org/v2/everything?q=health+exercise+diet&sortBy=popularity&apiKey=2b9b16291aa147558eef159456206f46";

  Future<List<Article>> getArticle() async {
    try {
      Response res = await get(Uri.parse(_endPointUrl));

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['articles'];
        List<Article> articles =
            body.map((dynamic item) => Article.fromJson(item)).toList();

        return articles;
      } else {
        throw ("Can't get the Articles");
      }
    } catch (e) {
      return [];
    }
  }
}
