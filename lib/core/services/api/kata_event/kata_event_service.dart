import 'package:codelink_mobile/core/ioc/definitions/kata_event/kata_event_service.interface.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/kata_event/kata_event.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';
import 'package:codelink_mobile/core/services/api/secure_api_service.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/http/http_request.dart';
import 'package:http/http.dart';

class KataEventService extends SecureApiService implements IKataEventService {

  static String get _apiUrl =>
      EnvironmentService.get(EnvironmentVariable.API_URL);
  static String get _endPoint => _apiUrl + '/code/kataEvent';

  @override
  Future<ServiceResponse<List<KataEvent>>> getAllKataEvent() async {
    Map<String, String> headers = await getHeaders();
    final Response response = await HttpRequest.get(_endPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeListFromBodyString(response.body, KataEvent().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

}