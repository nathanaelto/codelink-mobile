import 'package:codelink_mobile/core/models/utils/codable.dart';

class IsFollowResponse implements Decodable<IsFollowResponse, Map<String, dynamic>> {
  late IsFollowData data;

  @override
  IsFollowResponse decode(Map<String, dynamic> jsonObject) {
    IsFollowResponse isFollowResponse = IsFollowResponse();
    isFollowResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', IsFollowData().decode);
    return isFollowResponse;
  }
}

class IsFollowData implements Decodable<IsFollowData, Map<String, dynamic>> {
  late bool isFollowUser;

  @override
  IsFollowData decode(Map<String, dynamic> jsonObject) {
    IsFollowData isFollowData = IsFollowData();
    isFollowData.isFollowUser = DecodableTools.decodeBool(jsonObject, 'isFollowUser');
    return isFollowData;
  }


}