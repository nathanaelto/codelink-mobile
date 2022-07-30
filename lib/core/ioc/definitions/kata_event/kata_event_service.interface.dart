import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/kata_event/kata_event.dart';

abstract class IKataEventService {
  Future<ServiceResponse<List<KataEvent>>> getAllKataEvent();
}