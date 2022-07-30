import 'package:codelink_mobile/core/models/utils/codable.dart';

class User implements Decodable<User, Map<String, dynamic>> {
  late String id;
  late String email;
  late String username;
  late String? imageUrl;
  late List<String> follows;
  late List<String> followers;

  @override
  User decode(Map<String, dynamic> jsonObject) {
    User user = User();
    user.id = DecodableTools.decodeString(jsonObject, 'id');
    user.email = DecodableTools.decodeString(jsonObject, 'email');
    user.username = DecodableTools.decodeString(jsonObject, 'username');
    user.follows = DecodableTools.decodeStringList(jsonObject, 'follows');
    user.followers = DecodableTools.decodeStringList(jsonObject, 'followers');
    user.imageUrl = DecodableTools.decodeNullableString(jsonObject, 'image_url');
    return user;
  }
}