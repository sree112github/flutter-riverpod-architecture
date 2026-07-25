import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig{

  static Future<void> init() async{

      await dotenv.load(fileName: ".env");
  
  }


   // Safe getter for USE_MOCK (Defaults to false if missing)
  static bool get useMock {
    return dotenv.env['USE_MOCK'] == 'true';
  }
  // Safe getter for BASE_URL
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'https://default.url.com';
  }
}