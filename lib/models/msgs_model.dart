import 'dart:convert';

class Message {
  String? id;
  String? conversationId;
  String? senderId;
  String? content;
  dynamic msgType;
  String? fileUrl;
  DateTime? createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.msgType,
    required this.fileUrl,
    required this.createdAt,
  });

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      content: json['content'],
      msgType: json['msg_type'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']), // Convert string to DateTime
    );
  }

  // Method to convert a Message instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'msg_type': msgType,
      'file_url': fileUrl,
      'created_at': createdAt!.toIso8601String(), // Convert DateTime to string
    };
  }
}