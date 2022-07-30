import 'package:codelink_mobile/core/models/articles/like.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class LikeResponse implements Decodable<LikeResponse, Map<String, dynamic>> {
  late String message;
  late LikeData data;

  @override
  LikeResponse decode(Map<String, dynamic> jsonObject) {
    LikeResponse fetchLikeResponse = LikeResponse();
    fetchLikeResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    fetchLikeResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', LikeData().decode);
    return fetchLikeResponse;
  }
  
}


class LikeData implements Decodable<LikeData, Map<String, dynamic>> {
  late Like? like;
  
  @override
  LikeData decode(Map<String, dynamic> jsonObject) {
    LikeData fetchLikeData = LikeData();
    fetchLikeData.like = DecodableTools.decodeNullableNestedObject(jsonObject, 'like', Like().decode);
    return fetchLikeData;
  }
  
}