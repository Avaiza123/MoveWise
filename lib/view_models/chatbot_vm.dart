import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_model.dart';

class ChatBotController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;

  // ⚠️ Move this to secure storage or .env
  final String apiKey = "AIzaSyBRGq2Cq2RpshGZw4vtRfaYaVN8LNKsPw8";

  void addUserMessage(String text) {
    messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    sendMessage(text);
  }

  Future<void> sendMessage(String userMessage) async {
    isLoading.value = true;

    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userMessage}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final botMessage =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (botMessage != null) {
          messages.add(ChatMessage(
            text: botMessage.trim(),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        } else {
          messages.add(ChatMessage(
            text: "⚠️ No response from Gemini.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        }
      } else {
        final errorData = jsonDecode(response.body);
        messages.add(ChatMessage(
          text:
          "⚠️ API Error ${response.statusCode}: ${errorData['error']?['message'] ?? 'Unknown error'}",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      messages.add(ChatMessage(
        text: "❌ Exception: $e",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    isLoading.value = false;
  }
}
