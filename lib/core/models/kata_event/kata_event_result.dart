import 'package:codelink_mobile/core/models/utils/codable.dart';

class KataEventResult implements Decodable<KataEventResult, Map<String, dynamic>> {
  late String userId;
  late String username;
  late String kataAnswerId;
  late String time;
  late int status;

  @override
  KataEventResult decode(Map<String, dynamic> jsonObject) {
    KataEventResult kataEventResult = KataEventResult();
    kataEventResult.userId = DecodableTools.decodeString(jsonObject, "userId");
    kataEventResult.username = DecodableTools.decodeString(jsonObject, "username");
    kataEventResult.kataAnswerId = DecodableTools.decodeString(jsonObject, "kataAnswerId");
    kataEventResult.time = DecodableTools.decodeString(jsonObject, "time");
    kataEventResult.status = DecodableTools.decodeInt(jsonObject, "status");
    return kataEventResult;
  }

}