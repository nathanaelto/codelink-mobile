import 'dart:convert';

import 'package:codelink_mobile/core/models/utils/codable.dart';

class Login implements Encodable {
  String email;
  String password;

  Login({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password
    };
  }

  @override
  String encode() {
    return jsonEncode(toMap());
  }
}