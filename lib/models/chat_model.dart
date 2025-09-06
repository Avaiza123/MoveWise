class ChatMessage {
  final String text;
  final bool isUser; // true = user, false = bot
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
