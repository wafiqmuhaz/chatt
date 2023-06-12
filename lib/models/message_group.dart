class MessageGroup {
  final String messageId;
  final String message;
  final String senderName;
  final String imageUrl;
  final String replyToMessageId;
  final String replyToSenderName;
  final String replyToContent;

  MessageGroup({
    required this.messageId,
    required this.message,
    required this.senderName,
    required this.imageUrl,
    required this.replyToMessageId,
    required this.replyToSenderName,
    required this.replyToContent,
  });
}
