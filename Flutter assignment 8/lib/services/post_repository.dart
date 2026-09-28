import '../models/fetch_result.dart';
import '../models/post.dart';
import 'api_service.dart';
import 'cache_service.dart';

/// Exception thrown when cache-only retrieval is requested but no cache exists.
class NoCacheException implements Exception {
  final String message;
  NoCacheException([this.message = 'No cached posts found in SharedPreferences.']);

  @override
  String toString() => 'NoCacheException: $message';
}

/// Repository coordinating API requests with local SharedPreferences caching.
class PostRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  PostRepository({
    ApiService? apiService,
    CacheService? cacheService,
  })  : _apiService = apiService ?? ApiService(),
        _cacheService = cacheService ?? CacheService();

  /// Fetches posts. Supports forced API fetch, cache-only retrieval, and offline fallback.
  Future<FetchResult> fetchPosts({
    bool cacheOnly = false,
    bool simulateOffline = false,
  }) async {
    // 1. Cache-only mode requested
    if (cacheOnly) {
      final List<Post>? cached = await _cacheService.getCachedPosts();
      final DateTime? cachedAt = await _cacheService.getLastCachedTime();

      if (cached != null && cached.isNotEmpty) {
        return FetchResult(
          posts: cached,
          source: DataSource.cache,
          timestamp: cachedAt ?? DateTime.now(),
          noticeMessage: 'Retrieved directly from SharedPreferences cache.',
        );
      } else {
        throw NoCacheException(
          'No cached data found in SharedPreferences. Please fetch from the live API first.',
        );
      }
    }

    // 2. Simulated offline mode requested
    if (simulateOffline) {
      final List<Post>? cached = await _cacheService.getCachedPosts();
      final DateTime? cachedAt = await _cacheService.getLastCachedTime();

      if (cached != null && cached.isNotEmpty) {
        return FetchResult(
          posts: cached,
          source: DataSource.cache,
          timestamp: cachedAt ?? DateTime.now(),
          noticeMessage:
              'Simulated Offline Mode: Displaying saved posts from SharedPreferences.',
        );
      } else {
        throw ApiException(
          'Simulated Offline Mode: No cached posts available in SharedPreferences.',
        );
      }
    }

    // 3. Live API Fetch with automatic fallback to cache
    try {
      final List<Post> livePosts = await _apiService.fetchPosts();
      // Cache the freshly fetched posts in SharedPreferences
      await _cacheService.savePosts(livePosts);

      return FetchResult(
        posts: livePosts,
        source: DataSource.live,
        timestamp: DateTime.now(),
        noticeMessage: null,
      );
    } catch (error) {
      // Attempt fallback to local SharedPreferences cache
      final List<Post>? cached = await _cacheService.getCachedPosts();
      final DateTime? cachedAt = await _cacheService.getLastCachedTime();

      if (cached != null && cached.isNotEmpty) {
        final String reason = error is ApiException
            ? error.message
            : 'Unable to reach the server';

        return FetchResult(
          posts: cached,
          source: DataSource.cache,
          timestamp: cachedAt ?? DateTime.now(),
          noticeMessage:
              '$reason. Showing last cached data from SharedPreferences.',
        );
      }

      // No cache fallback available; rethrow error to FutureBuilder
      if (error is ApiException) rethrow;
      throw ApiException('Failed to fetch posts and no local cache was found.');
    }
  }

  /// Clears stored cache in SharedPreferences.
  Future<void> clearCache() => _cacheService.clearCache();

  /// Checks if any cache exists.
  Future<bool> hasCache() => _cacheService.hasCache();

  /// Gets the last cache timestamp.
  Future<DateTime?> getLastCachedTime() => _cacheService.getLastCachedTime();
}
