import 'package:codelink_mobile/core/models/articles/comment.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class Article implements Decodable<Article, Map<String, dynamic>> {
  late String id;
  late String name;
  late String description;
  late String category;
  late String userId;
  late String author;
  late String imageUrl;
  late DateTime createdAt;
  late DateTime updatedAt;
  late List<Comment> comments;
  late int likes;

  @override
  Article decode(Map<String, dynamic> jsonObject) {
    Article article = Article();
    article.id = DecodableTools.decodeString(jsonObject, 'id');
    article.name = DecodableTools.decodeString(jsonObject, 'name');
    article.description = DecodableTools.decodeString(jsonObject, 'description');
    article.category = DecodableTools.decodeString(jsonObject, 'category');
    article.userId = DecodableTools.decodeString(jsonObject, 'user_id');
    article.author = DecodableTools.decodeString(jsonObject, 'author');
    article.imageUrl = DecodableTools.decodeString(jsonObject, 'image_url');
    article.createdAt = DecodableTools.decodeDate(jsonObject, 'created_at');
    article.updatedAt = DecodableTools.decodeDate(jsonObject, 'updated_at');
    article.comments = DecodableTools.decodeNestedList(jsonObject, 'comments', Comment().decode);
    article.likes = DecodableTools.decodeInt(jsonObject, 'likes');
    return article;
  }

}