import 'dart:convert';

import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/models/articles/comment.dart';
import 'package:codelink_mobile/core/models/articles/create_comment_response.dart';
import 'package:codelink_mobile/core/models/articles/fetch_articles_response.dart';
import 'package:codelink_mobile/core/models/articles/like_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';
import 'package:codelink_mobile/core/services/api/secure_api_service.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/http/http_request.dart';
import 'package:http/http.dart';

class BlogService extends SecureApiService implements IBlogService {
  static String get _apiUrl =>
      EnvironmentService.get(EnvironmentVariable.API_URL);
  static String get _articleEndPoint => _apiUrl + '/articles';
  static String get _commentEndPoint => _articleEndPoint + '/comment';
  static String get _likeEndPoint => _articleEndPoint + '/like';

  @override
  Future<ServiceResponse<FetchArticlesResponse>> fetchArticlesOfUser(
      String userId) async {
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.get(_articleEndPoint + "/ofUser/$userId",
        headers: headers);

    print(response.statusCode);
    print(response.body);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString<FetchArticlesResponse>(
            response.body, FetchArticlesResponse().decode);
      case 204:
        FetchArticlesResponse fetchArticlesResponse = FetchArticlesResponse();
        FetchArticlesData fetchArticlesData = FetchArticlesData();
        fetchArticlesData.articles = [];
        fetchArticlesResponse.message = "No content";
        fetchArticlesResponse.data = fetchArticlesData;
        return ServiceResponse.success(fetchArticlesResponse);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<FetchArticlesResponse>> fetchArticlesOfFollow() async {
    String endpoint = '$_articleEndPoint/follows';
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.get(endpoint, headers: headers);
    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString<FetchArticlesResponse>(
            response.body, FetchArticlesResponse().decode);
      case 204:
        FetchArticlesResponse fetchArticlesResponse = FetchArticlesResponse();
        FetchArticlesData fetchArticlesData = FetchArticlesData();
        fetchArticlesData.articles = [];
        fetchArticlesResponse.message = "No content";
        fetchArticlesResponse.data = fetchArticlesData;
        return ServiceResponse.success(fetchArticlesResponse);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<FetchArticlesResponse>> fetchAllArticles() async {
    String endpoint = '$_articleEndPoint/all';
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.get(endpoint, headers: headers);
    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString<FetchArticlesResponse>(
            response.body, FetchArticlesResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<CreateCommentResponse>> createComment(
      String articleId, String content) async {
    Comment createComment = Comment();
    createComment.articleId = articleId;
    createComment.description = content;

    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.post(_commentEndPoint,
        headers: headers, body: createComment.encode());

    switch (response.statusCode) {
      case 201:
        return DecodableTools.decodeFromBodyString<CreateCommentResponse>(
            response.body, CreateCommentResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<LikeResponse>> getAllMyLikes() async {
    Map<String, String> headers = await getHeaders();
    final Response response = await HttpRequest.get(_likeEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString(response.body, LikeResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }

  }

  @override
  Future<ServiceResponse<LikeResponse>> likeArticle(String articleId) async {
    Map<String, dynamic> body = {
      'article_id': articleId,
      'comment_id': ""
    };
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.post(_likeEndPoint, headers: headers, body: jsonEncode(body));

    switch (response.statusCode) {
      case 201:
        return DecodableTools.decodeFromBodyString(response.body, LikeResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<LikeResponse>> likeComment(String commentId) async {
    Map<String, dynamic> body = {
      'article_id': "",
      'comment_id': commentId
    };
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.post(_likeEndPoint, headers: headers, body: jsonEncode(body));

    switch (response.statusCode) {
      case 201:
        return DecodableTools.decodeFromBodyString(response.body, LikeResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<bool>> unlikeArticle(String articleId) async {
    Map<String, dynamic> body = {
      'article_id': articleId,
      'comment_id': ""
    };
    Map<String, String> headers = await getHeaders();

    final Response response = await HttpRequest.patch(_likeEndPoint, headers: headers, body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        return ServiceResponse.success(true);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<bool>> unlikeComment(String commentId) async {
    Map<String, dynamic> body = {
      'article_id': "",
      'comment_id': commentId
    };
    Map<String, String> headers = await getHeaders();
    final Response response = await HttpRequest.patch(_likeEndPoint, headers: headers, body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        return ServiceResponse.success(true);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }


}
