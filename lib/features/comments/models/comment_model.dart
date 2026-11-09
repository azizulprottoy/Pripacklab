class ReplyModel {
  final String id;
  final String userName;
  final String message;
  final int likes;
  final DateTime? createdAt;

  ReplyModel({
    required this.id,
    required this.userName,
    required this.message,
    this.likes = 0,
    this.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
        id: json['_id']?.toString() ?? '',
        userName: json['userName'] ?? '',
        message: json['message'] ?? '',
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}

class CommentModel {
  final String id;
  final String productId;
  final String userName;
  final String message;
  final int likes;
  final String status;
  final DateTime? createdAt;
  final List<ReplyModel> replies;

  CommentModel({
    required this.id,
    required this.productId,
    required this.userName,
    required this.message,
    this.likes = 0,
    this.status = 'show',
    this.createdAt,
    this.replies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['_id']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        userName: json['userName'] ?? '',
        message: json['message'] ?? '',
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        status: json['status'] ?? 'show',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
        replies: (json['replies'] as List? ?? [])
            .map((e) => ReplyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
