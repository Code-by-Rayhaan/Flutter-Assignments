import 'package:flutter_assignment_8/models/post.dart';
import 'package:flutter_assignment_8/services/cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('savePosts and getCachedPosts store and retrieve from SharedPreferences',
        () async {
      final cacheService = CacheService();
      final samplePosts = [
        const Post(id: 1, userId: 1, title: 'Cached 1', body: 'Body 1'),
        const Post(id: 2, userId: 2, title: 'Cached 2', body: 'Body 2'),
      ];

      expect(await cacheService.hasCache(), false);

      await cacheService.savePosts(samplePosts);

      expect(await cacheService.hasCache(), true);

      final cached = await cacheService.getCachedPosts();
      expect(cached, isNotNull);
      expect(cached!.length, 2);
      expect(cached[0].title, 'Cached 1');
      expect(cached[1].title, 'Cached 2');

      final timestamp = await cacheService.getLastCachedTime();
      expect(timestamp, isNotNull);
      expect(DateTime.now().difference(timestamp!).inMinutes < 1, true);
    });

    test('clearCache removes data from SharedPreferences', () async {
      final cacheService = CacheService();
      final samplePosts = [
        const Post(id: 10, userId: 1, title: 'Title', body: 'Body'),
      ];

      await cacheService.savePosts(samplePosts);
      expect(await cacheService.hasCache(), true);

      await cacheService.clearCache();
      expect(await cacheService.hasCache(), false);

      final cached = await cacheService.getCachedPosts();
      expect(cached, isNull);

      final timestamp = await cacheService.getLastCachedTime();
      expect(timestamp, isNull);
    });
  });
}
