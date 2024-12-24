import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiUrl => const String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }
}