import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  // Get the key from flutter_dotenv
  String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  Future<String> sendMessage(List<Map<String, String>> conversation) async {
    try {
      if (_apiKey.isEmpty) {
        return "Error: API Key is missing. Please ensure your .env file is set up correctly with OPENAI_API_KEY.";
      }

      final url = Uri.parse("https://api.openai.com/v1/chat/completions");
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            ...conversation
          ],
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        try {
          final errorBody = json.decode(response.body);
          return "OpenAI Error: ${errorBody['error']['message']}";
        } catch (_) {
          return "Server Error (${response.statusCode})";
        }
      }
    } catch (e) {
      return "Connection Error: $e";
    }
  }
}
