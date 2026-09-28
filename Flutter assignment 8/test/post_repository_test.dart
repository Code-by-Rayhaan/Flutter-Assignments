import 'package:flutter_assignment_8/models/fetch_result.dart';
import 'package:flutter_assignment_8/models/post.dart';
import 'package:flutter_assignment_8/services/api_service.dart';
import 'package:flutter_assignment_8/services/cache_service.dart';
import 'package:flutter_assignment_8/services/post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSuccessApiService extends ApiService {
  final List<Post> samplePosts;
  MockSuccessApiService(this.samplePosts);

  @override
  Future<List<Post>> fetchPosts() async {
    return samplePosts;
  }
}

class MockFailingApiService extends ApiService {
  @override
  Future<List<Post>> fetchPosts() async {
    throw ApiException('Connection failed: Server unavailable');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PostRepository Tests', () {
    final samplePosts = [
      const Post(id: 1, userId: 1, title: 'Live Title 1', body: 'Live Body 1'),
      const Post(id: 2, userId: 1, title: 'Live Title 2', body: 'Live Body 2'),
    ];

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Live API fetch succeeds and automatically updates SharedPreferences cache',
        () async {
      final cacheService = CacheService();
      final repository = PostRepository(
        apiService: MockSuccessApiService(samplePosts),
        cacheService: cacheService,
      );

      final result = await repository.fetchPosts();

      expect(result.source, DataSource.live);
      expect(result.isLive, true);
      expect(result.posts.length, 2);
      expect(result.posts[0].title, 'Live Title 1');

      // Verify that cache was populated
      expect(await cacheService.hasCache(), true);
      final cached = await cacheService.getCachedPosts();
      expect(cached?.length, 2);
    });

    test('API failure gracefully falls back to cached posts in SharedPreferences',
        () async {
      final cacheService = CacheService();
      // First save some posts to cache
      await cacheService.savePosts(samplePosts);

      // Now create repo with failing API
      final repository = PostRepository(
        apiService: MockFailingApiService(),
        cacheService: cacheService,
      );

      final result = await repository.fetchPosts();

      expect(result.source, DataSource.cache);
      expect(result.isCache, true);
      expect(result.posts.length, 2);
      expect(result.noticeMessage, contains('Server unavailable'));
    });

    test('API failure throws error when no cache is available', () async {
      final cacheService = CacheService();
      final repository = PostRepository(
        apiService: MockFailingApiService(),
        cacheService: cacheService,
      );

      expect(() => repository.fetchPosts(), throwsA(isA<ApiException>()));
    });

    test('fetchPosts with cacheOnly=true retrieves from SharedPreferences',
        () async {
      final cacheService = CacheService();
      await cacheService.savePosts(samplePosts);

      final repository = PostRepository(
        apiService: MockFailingApiService(),
        cacheService: cacheService,
      );

      final result = await repository.fetchPosts(cacheOnly: true);

      expect(result.source, DataSource.cache);
      expect(result.posts.length, 2);
      expect(result.noticeMessage, contains('SharedPreferences cache'));
    });
  });
}
