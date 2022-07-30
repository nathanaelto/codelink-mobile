import 'package:codelink_mobile/core/models/utils/codable.dart';

class LoginResponse implements Decodable<LoginResponse, Map<String, dynamic>> {

  late String message;
  late LoginData data;

  @override
  LoginResponse decode(Map<String, dynamic> jsonObject) {
    LoginResponse loginResponse = LoginResponse();
    loginResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    loginResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', LoginData().decode);
    return loginResponse;
  }

}

class LoginData implements Decodable<LoginData, Map<String, dynamic>> {
  late String token;

  @override
  LoginData decode(Map<String, dynamic> jsonObject) {
    LoginData data = LoginData();
    data.token = DecodableTools.decodeString(jsonObject, 'token');
    return data;
  }

}