import 'dart:convert';

/// Data model representing a Post item from JSONPlaceholder REST API.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// Creates a [Post] instance from a JSON map.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.parse(json['userId'].toString()),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  /// Converts the [Post] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  /// Deserializes a list of dynamic JSON maps into a `List<Post>`.
  static List<Post> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Encodes a list of [Post] objects into a JSON string for SharedPreferences caching.
  static String encodeList(List<Post> posts) {
    final List<Map<String, dynamic>> mapList =
        posts.map((post) => post.toJson()).toList();
    return jsonEncode(mapList);
  }

  /// Decodes a JSON string retrieved from SharedPreferences into a list of [Post] objects.
  static List<Post> decodeList(String jsonString) {
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return fromJsonList(decoded);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          body == other.body;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ title.hashCode ^ body.hashCode;

  @override
  String toString() =>
      'Post(id: $id, userId: $userId, title: $title, body: $body)';
}
