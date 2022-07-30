import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/blog/blog_service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/global/global.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/kata_event/kata_event_service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/secure_api_service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/secure_cache.service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/services/api/authentication/authentication.service.dart';
import 'package:codelink_mobile/core/services/api/blog/blog_service.dart';
import 'package:codelink_mobile/core/services/api/kata_event/kata_event_service.dart';
import 'package:codelink_mobile/core/services/api/secure_api_service.dart';
import 'package:codelink_mobile/core/services/api/user/user_service.dart';
import 'package:codelink_mobile/core/services/secure_cache/authentication/authentication.dao.dart';
import 'package:codelink_mobile/core/services/secure_cache/global/global.dao.dart';
import 'package:codelink_mobile/core/services/secure_cache/secure_cache.service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final getIt = GetIt.instance;

void setup() {

  // CACHE SERVICE BASE
  getIt.registerSingleton<ISecureCacheService>(SecureCacheService());

  // SECURE CACHE DAO
  getIt.registerSingleton<IAuthenticationDao>(AuthenticationDao());
  getIt.registerSingleton<IGlobalDao>(GlobalDao());

  // SECURE SERVICE BASE
  getIt.registerSingleton<ISecureApiService>(SecureApiService());

  // SERVICES
  getIt.registerSingleton<IAuthenticationService>(AuthenticationService());
  getIt.registerSingleton<IBlogService>(BlogService());
  getIt.registerSingleton<IUserService>(UserService());
  getIt.registerSingleton<IKataEventService>(KataEventService());

}