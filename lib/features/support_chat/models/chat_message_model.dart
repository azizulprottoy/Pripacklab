class ChatMessageModel {
  final String supportId;
  final String bId;
  final String bName;
  final String text;
  final String sender;
  final DateTime time;

  ChatMessageModel({
    required this.supportId,
    required this.bId,
    required this.bName,
    required this.text,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'supportId': supportId,
        'bId': bId,
        'bName': bName,
        'text': text,
        'sender': sender,
        'time': time.toIso8601String(),
      };

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        supportId: json['supportId']?.toString() ?? '',
        bId: json['bId']?.toString() ?? '',
        bName: json['bName']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        sender: json['sender']?.toString() ?? '',
        time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      );
}
