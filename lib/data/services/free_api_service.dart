import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FreeApiService {
  // Get the key from flutter_dotenv (even if not currently used by this specific URL)
  String get _apiKey => dotenv.env['FREE_API_KEY'] ?? '';

  // Using a very stable public API that doesn't require keys and works on Web
  Future<String> getResponse() async {
    try {
      // You can now use _apiKey if you switch to an API that requires one
      final res = await http.get(
        Uri.parse("https://official-joke-api.appspot.com/random_joke"),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return "Free API Joke:\n\n${data['setup']}\n— ${data['punchline']}";
      } else {
        return "The Free API is currently taking a break. Please try again soon!";
      }
    } catch (e) {
      return "Assistant: I'm here! I'm having a little trouble reaching the joke server, but the app is connected and working.";
    }
  }
}
