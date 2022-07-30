import 'package:codelink_mobile/core/models/kata_event/kata_event.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class GetAllKataEventResponse implements Decodable<GetAllKataEventResponse, Map<String, dynamic>> {

  late List<KataEvent> kataEvents;

  @override
  GetAllKataEventResponse decode(Map<String, dynamic> jsonObject) {
    GetAllKataEventResponse getAllKataEventResponse = GetAllKataEventResponse();
    // getAllKataEventResponse.kataEvents = DecodableTools.decodeListFromBodyString(jsonObject, KataEvent().decode);
    return getAllKataEventResponse;
  }

}