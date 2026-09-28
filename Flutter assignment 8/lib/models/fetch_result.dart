import 'post.dart';

/// Indicates the origin of the fetched posts.
enum DataSource {
  /// Fetched directly from the JSONPlaceholder REST API over the network.
  live,

  /// Retrieved from local SharedPreferences cache.
  cache,
}

/// Wrapper model containing the fetched posts, source metadata, and cache timestamp.
class FetchResult {
  final List<Post> posts;
  final DataSource source;
  final DateTime timestamp;
  final String? noticeMessage;

  const FetchResult({
    required this.posts,
    required this.source,
    required this.timestamp,
    this.noticeMessage,
  });

  bool get isLive => source == DataSource.live;
  bool get isCache => source == DataSource.cache;
}
