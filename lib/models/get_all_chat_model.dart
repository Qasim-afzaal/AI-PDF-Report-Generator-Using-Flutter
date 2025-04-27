class ConversationResponse {
  final bool success;
  final String message;
  final List<ConversationData> data;

  ConversationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((e) => ConversationData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ConversationData {
  final String conversationId;
  final String? conversationName;
  final String? threadId;
  final String? chatType;
  final String createdAt;

  ConversationData({
    required this.conversationId,
    this.conversationName,
     required this.threadId,
    this.chatType,
    required this.createdAt,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      conversationId: json['conversation_id'],
      conversationName: json['conversation_name'],
        threadId: json['thread_id'],
      chatType: json['chat_type'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'conversation_name': conversationName,
       'thread_id': threadId,
      'chat_type': chatType,
      'created_at': createdAt,
    };
  }
}
