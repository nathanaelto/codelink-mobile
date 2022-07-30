import 'package:codelink_mobile/core/models/articles/article.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class FetchArticlesResponse implements Decodable<FetchArticlesResponse, Map<String, dynamic>> {
  late String message;
  late FetchArticlesData data;

  @override
  FetchArticlesResponse decode(Map<String, dynamic> jsonObject) {
    FetchArticlesResponse fetchArticlesResponse = FetchArticlesResponse();
    fetchArticlesResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    fetchArticlesResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', FetchArticlesData().decode);
    return fetchArticlesResponse;
  }

}

class FetchArticlesData implements Decodable<FetchArticlesData, Map<String, dynamic>> {
  late List<Article> articles;

  @override
  FetchArticlesData decode(Map<String, dynamic> jsonObject) {
    FetchArticlesData fetchArticlesData = FetchArticlesData();
    fetchArticlesData.articles = DecodableTools.decodeNestedList(jsonObject, 'articles', Article().decode);
    return fetchArticlesData;
  }

}