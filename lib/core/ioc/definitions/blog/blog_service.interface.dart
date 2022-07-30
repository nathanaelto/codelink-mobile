import 'package:codelink_mobile/core/models/articles/create_comment_response.dart';
import 'package:codelink_mobile/core/models/articles/fetch_articles_response.dart';
import 'package:codelink_mobile/core/models/articles/like_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';

abstract class IBlogService {
  Future<ServiceResponse<FetchArticlesResponse>> fetchArticlesOfUser(String userId);
  Future<ServiceResponse<FetchArticlesResponse>> fetchArticlesOfFollow();
  Future<ServiceResponse<FetchArticlesResponse>> fetchAllArticles();
  Future<ServiceResponse<CreateCommentResponse>> createComment(String articleId, String content);
  /// TODO : Delete article
  /// TODO : Delete comment
  /// TODO : Update comment
  Future<ServiceResponse<LikeResponse>> likeArticle(String articleId);
  Future<ServiceResponse<LikeResponse>> likeComment(String commentId);
  Future<ServiceResponse<LikeResponse>> getAllMyLikes();
  Future<ServiceResponse<bool>> unlikeArticle(String articleId);
  Future<ServiceResponse<bool>> unlikeComment(String commentId);
}