import 'dart:convert';

import 'package:codelink_mobile/core/models/utils/codable.dart';

class Comment implements Encodable, Decodable<Comment, Map<String, dynamic>> {
  late String id;
  late String description;
  late String userId;
  late String author;
  late String articleId;
  late DateTime createdAt;
  late DateTime updatedAt;

  @override
  Comment decode(Map<String, dynamic> jsonObject) {
    Comment comment = Comment();
    comment.id = DecodableTools.decodeString(jsonObject, "id");
    comment.description =
        DecodableTools.decodeString(jsonObject, 'description');
    comment.userId = DecodableTools.decodeString(jsonObject, 'user_id');
    comment.author = DecodableTools.decodeString(jsonObject, 'author');
    comment.articleId = DecodableTools.decodeString(jsonObject, 'article_id');
    comment.createdAt = DecodableTools.decodeDate(jsonObject, 'created_at');
    comment.updatedAt = DecodableTools.decodeDate(jsonObject, 'updated_at');
    return comment;
  }

  Map<String, dynamic> toMap() {
    return {'description': description, 'article_id': articleId};
  }

  @override
  String encode() {
    return jsonEncode(toMap());
  }
}
