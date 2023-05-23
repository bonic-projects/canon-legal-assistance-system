class ChatMessage {
  final String id;
  final String senderId;
  final String message;
  // final int securityLevel;
  final DateTime timestamp;
  final String fileLink;
  final String fileFormat;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    // required this.securityLevel,
    required this.timestamp,
    required this.fileLink,
    required this.fileFormat,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      message: json['message'],
      // securityLevel: json['securityLevel'] ?? 0,
      timestamp: json['timestamp'].toDate(),
      fileLink: json['fileLink'] ?? "",
      fileFormat: json['fileFormat'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      // 'securityLevel': securityLevel,
      'fileLink': fileLink,
      'fileFormat': fileFormat,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? message,
    int? securityLevel,
    String? fileLink,
    String? fileFormat,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      // securityLevel: securityLevel ?? this.securityLevel,
      fileLink: fileLink ?? this.fileLink,
      fileFormat: fileFormat ?? this.fileFormat,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
