import 'package:codelink_mobile/core/ioc/definitions/global/global.dao.interface.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/secure_cache/secure_cache.service.dart';

class GlobalDao extends SecureCacheService implements IGlobalDao {
  static final String seed = EnvironmentService.get(EnvironmentVariable.SEED);

  static final String firstUsageKey = '${seed}_FIRST_USAGE_KEY';

  @override
  Future<bool> isFirstAppUsage() async {
    return Future<bool>.delayed(
      const Duration(milliseconds: 500),
        () async {
          String? isFirstUsage = await get(firstUsageKey);
          if (isFirstUsage == null) {
            await set(firstUsageKey, 'true');
            return true;
          }
          return false;
        },
    );
  }

}