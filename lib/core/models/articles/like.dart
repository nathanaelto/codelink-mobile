import 'package:codelink_mobile/core/models/utils/codable.dart';

class Like implements Decodable<Like, Map<String, dynamic>> {

  late String userId;
  late List<String> articlesId;
  late List<String> commentsId;

  @override
  Like decode(Map<String, dynamic> jsonObject) {
    Like like = Like();
    like.userId = DecodableTools.decodeString(jsonObject, 'user_id');
    like.articlesId = DecodableTools.decodeStringList(jsonObject, 'articles_id');
    like.commentsId = DecodableTools.decodeStringList(jsonObject, 'comments_id');
    return like;
  }

  static Like getDefault() {
    Like like = Like();
    like.articlesId = [];
    like.commentsId = [];
    return like;
  }
}