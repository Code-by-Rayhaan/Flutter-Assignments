import '../exceptions/api_exceptions.dart';

/// Represents a post published by a user.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final int? likesCount; // Nullable - may not be tracked or available
  final DateTime publishedAt;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.likesCount,
    required this.publishedAt,
  });

  /// Factory constructor to parse JSON with null safety checks.
  factory Post.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final userId = json['userId'] as int?;
    final title = json['title'] as String?;
    final body = json['body'] as String?;
    final publishedAtRaw = json['publishedAt'] as String?;

    if (id == null) throw const DataParsingException('Post id is missing', 'id');
    if (userId == null) throw const DataParsingException('User id is missing', 'userId');
    if (title == null || title.isEmpty) throw const DataParsingException('Post title is missing', 'title');
    if (body == null) throw const DataParsingException('Post body is missing', 'body');

    DateTime parsedDate;
    if (publishedAtRaw != null) {
      parsedDate = DateTime.tryParse(publishedAtRaw) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Post(
      id: id,
      userId: userId,
      title: title,
      body: body,
      likesCount: json['likesCount'] as int?, // May be null
      publishedAt: parsedDate,
    );
  }

  /// Displays post summary with fallback for null likes count.
  String get displaySummary {
    final likes = likesCount != null ? '$likesCount likes' : 'Likes hidden';
    return '#$id: "$title" ($likes) - ${publishedAt.toIso8601String().split('T').first}';
  }

  @override
  String toString() => displaySummary;
}
