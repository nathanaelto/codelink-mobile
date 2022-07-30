import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class CreateUserResponse implements Decodable<CreateUserResponse, Map<String, dynamic>> {

  late String message;
  late CreateUserData data;

  @override
  CreateUserResponse decode(Map<String, dynamic> jsonObject) {
    CreateUserResponse createUserResponse = CreateUserResponse();
    createUserResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    createUserResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', CreateUserData().decode);
    return createUserResponse;
  }

}

class CreateUserData implements Decodable<CreateUserData, Map<String, dynamic>> {
  late String token;
  late User user;

  @override
  CreateUserData decode(Map<String, dynamic> jsonObject) {
    CreateUserData createUserData = CreateUserData();
    createUserData.token = DecodableTools.decodeString(jsonObject, 'token');
    createUserData.user = DecodableTools.decodeNestedObject(jsonObject, 'user', User().decode);
    return createUserData;
  }

}