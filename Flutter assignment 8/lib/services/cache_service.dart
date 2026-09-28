import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

/// Service responsible for local caching using SharedPreferences.
class CacheService {
  static const String keyPostsJson = 'cached_posts_json_v1';
  static const String keyCachedAt = 'cached_posts_timestamp_v1';

  final SharedPreferences? prefs;

  CacheService({this.prefs});

  Future<SharedPreferences> _getPrefs() async {
    return prefs ?? await SharedPreferences.getInstance();
  }

  /// Caches the given list of [Post] objects and saves the current timestamp.
  Future<void> savePosts(List<Post> posts) async {
    final SharedPreferences prefs = await _getPrefs();
    final String encodedJson = Post.encodeList(posts);
    final String nowIso = DateTime.now().toIso8601String();

    await prefs.setString(keyPostsJson, encodedJson);
    await prefs.setString(keyCachedAt, nowIso);
  }

  /// Retrieves the cached list of [Post] objects from SharedPreferences.
  /// Returns `null` if no cache exists or if parsing fails.
  Future<List<Post>?> getCachedPosts() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? cachedJson = prefs.getString(keyPostsJson);

    if (cachedJson == null || cachedJson.trim().isEmpty) {
      return null;
    }

    try {
      return Post.decodeList(cachedJson);
    } catch (_) {
      // In case of corrupted cached data, clear and return null
      await clearCache();
      return null;
    }
  }

  /// Returns the DateTime when posts were last cached, or `null` if none.
  Future<DateTime?> getLastCachedTime() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? timestampStr = prefs.getString(keyCachedAt);

    if (timestampStr == null || timestampStr.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(timestampStr);
    } catch (_) {
      return null;
    }
  }

  /// Checks if valid cache data is available in SharedPreferences.
  Future<bool> hasCache() async {
    final SharedPreferences prefs = await _getPrefs();
    final String? cached = prefs.getString(keyPostsJson);
    return cached != null && cached.isNotEmpty;
  }

  /// Clears the stored posts and timestamp from SharedPreferences.
  Future<void> clearCache() async {
    final SharedPreferences prefs = await _getPrefs();
    await prefs.remove(keyPostsJson);
    await prefs.remove(keyCachedAt);
  }
}
