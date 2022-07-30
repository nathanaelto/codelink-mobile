import 'dart:convert';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class CreateUser implements Encodable {
  String email;
  String password;
  String username;
  String? imageUrl;

  CreateUser({required this.email, required this.password, required this.username, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'image_url': imageUrl
    };
  }

  @override
  String encode() {
    return jsonEncode(toMap());
  }
}