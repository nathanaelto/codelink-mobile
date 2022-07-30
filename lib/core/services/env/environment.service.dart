import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentVariable {
  API_URL,
  SEED,
}

extension Value on EnvironmentVariable {
  String get value {
    return toString().replaceFirst("EnvironmentVariable.", "");
  }
}

class EnvironmentService {
  static String get(EnvironmentVariable variable) {
    return dotenv.env[variable.value]!;
  }

  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
    var isEveryDefined = dotenv.isEveryDefined(
        EnvironmentVariable.values.map((envVar) => envVar.value));

    if (!isEveryDefined) {
      throw Exception("Missing env variable :< .");
    }
  }
}