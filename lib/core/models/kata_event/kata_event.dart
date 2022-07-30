import 'package:codelink_mobile/core/models/kata_event/kata_event_result.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';

class KataEvent implements Decodable<KataEvent, Map<String, dynamic>> {
  late String _id;
  late String kataId;
  late String name;
  late DateTime startDate;
  late DateTime endDate;
  late List<KataEventResult> kataEventResults;

  @override
  KataEvent decode(Map<String, dynamic> jsonObject) {
    KataEvent kataEvent = KataEvent();
    kataEvent._id = DecodableTools.decodeString(jsonObject, '_id');
    kataEvent.kataId = DecodableTools.decodeString(jsonObject, 'kataId');
    kataEvent.name = DecodableTools.decodeString(jsonObject, 'name');
    kataEvent.startDate = DecodableTools.decodeDate(jsonObject, 'startDate');
    kataEvent.endDate = DecodableTools.decodeDate(jsonObject, 'endDate');
    kataEvent.kataEventResults = DecodableTools.decodeNestedList(jsonObject, 'kataEventResults', KataEventResult().decode);
    return kataEvent;
  }
}