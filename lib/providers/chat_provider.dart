import 'package:flutter/material.dart';
import '../data/services/openai_service.dart';
import '../data/services/free_api_service.dart';

class ChatProvider extends ChangeNotifier {
  final OpenAIService openAI = OpenAIService();
  final FreeApiService freeApi = FreeApiService();

  bool useOpenAI = true;
  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;

  Future<void> sendMessage(String msg) async {
    if (msg.trim().isEmpty) return;

    messages.add({
      "role": "user",
      "text": msg,
      "time": DateTime.now(),
    });

    isTyping = true;
    notifyListeners();

    try {
      String reply;
      if (useOpenAI) {
        // Correctly formatting conversation history for OpenAI
        final List<Map<String, String>> history = messages
            .where((m) => m['role'] != null && m['text'] != null)
            .map((m) => {
                  "role": m['role'] == 'user' ? 'user' : 'assistant',
                  "content": m['text'].toString()
                })
            .toList();
            
        // Pass the full conversation history to the service
        reply = await openAI.sendMessage(history);
      } else {
        reply = await freeApi.getResponse();
      }

      messages.add({
        "role": "bot",
        "text": reply,
        "time": DateTime.now(),
      });
    } catch (e) {
      messages.add({
        "role": "bot",
        "text": "Error: ${e.toString()}",
        "time": DateTime.now(),
      });
    } finally {
      isTyping = false;
      notifyListeners();
    }
  }

  void toggleApi(bool val) {
    useOpenAI = val;
    notifyListeners();
  }
  
  void clearChat() {
    messages.clear();
    notifyListeners();
  }
}
