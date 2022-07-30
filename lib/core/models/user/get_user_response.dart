import 'package:codelink_mobile/core/models/user/user.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class GetUserResponse implements Decodable<GetUserResponse, Map<String, dynamic>> {
  late String message;
  late GetUserData data;

  @override
  GetUserResponse decode(Map<String, dynamic> jsonObject) {
    GetUserResponse getUserResponse = GetUserResponse();
    getUserResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    getUserResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', GetUserData().decode);
    return getUserResponse;
  }



}

class GetUserData implements Decodable<GetUserData, Map<String, dynamic>> {
  late User user;

  @override
  GetUserData decode(Map<String, dynamic> jsonObject) {
    GetUserData getUserData = GetUserData();
    getUserData.user = DecodableTools.decodeNestedObject(jsonObject, 'user', User().decode);
    return getUserData;
  }


}