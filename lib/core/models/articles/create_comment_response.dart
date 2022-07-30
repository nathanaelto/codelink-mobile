import 'package:codelink_mobile/core/models/articles/comment.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class CreateCommentResponse implements Decodable<CreateCommentResponse, Map<String, dynamic>> {
  late String message;
  late CreateCommentData data;

  @override
  CreateCommentResponse decode(Map<String, dynamic> jsonObject) {
    CreateCommentResponse createCommentResponse = CreateCommentResponse();
    createCommentResponse.message = DecodableTools.decodeString(jsonObject, 'message');
    createCommentResponse.data = DecodableTools.decodeNestedObject(jsonObject, 'data', CreateCommentData().decode);
    return createCommentResponse;
  }


}

class CreateCommentData implements Decodable<CreateCommentData, Map<String, dynamic>> {
  late Comment comment;

  @override
  CreateCommentData decode(Map<String, dynamic> jsonObject) {
    CreateCommentData createCommentData = CreateCommentData();
    createCommentData.comment = DecodableTools.decodeNestedObject(jsonObject, 'comment', Comment().decode);
    return createCommentData;
  }

}