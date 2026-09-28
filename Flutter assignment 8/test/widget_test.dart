import 'package:flutter/material.dart';
import 'package:flutter_assignment_8/models/post.dart';
import 'package:flutter_assignment_8/screens/post_list_screen.dart';
import 'package:flutter_assignment_8/services/api_service.dart';
import 'package:flutter_assignment_8/services/cache_service.dart';
import 'package:flutter_assignment_8/services/post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDelayedApiService extends ApiService {
  final List<Post> samplePosts;
  MockDelayedApiService(this.samplePosts);

  @override
  Future<List<Post>> fetchPosts() async {
    return samplePosts;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PostListScreen displays posts in FutureBuilder and filters with search',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final testPosts = [
      const Post(
        id: 1,
        userId: 1,
        title: 'Flutter and FutureBuilder',
        body: 'FutureBuilder is great for asynchronous UI.',
      ),
      const Post(
        id: 2,
        userId: 2,
        title: 'SharedPreferences Caching',
        body: 'Cache key-value data persistently in local storage.',
      ),
    ];

    final repo = PostRepository(
      apiService: MockDelayedApiService(testPosts),
      cacheService: CacheService(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: PostListScreen(repository: repo),
      ),
    );

    // Initial pump shows LoadingView or immediately resolves
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('JSONPlaceholder Posts'), findsOneWidget);
    expect(find.text('FutureBuilder + SharedPreferences'), findsOneWidget);

    // Verify Cache Status Badge
    expect(find.text('LIVE API'), findsOneWidget);
    expect(find.text('2 posts'), findsOneWidget);

    // Verify both posts are displayed
    expect(find.text('Flutter and FutureBuilder'), findsOneWidget);
    expect(find.text('SharedPreferences Caching'), findsOneWidget);

    // Test Search Filter
    await tester.enterText(find.byType(TextField), 'SharedPreferences');
    await tester.pumpAndSettle();

    // Post 2 matches, Post 1 does not
    expect(find.text('SharedPreferences Caching'), findsOneWidget);
    expect(find.text('Flutter and FutureBuilder'), findsNothing);
    expect(find.text('1 of 2 posts'), findsOneWidget);

    // Clear search
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    // Both posts return
    expect(find.text('Flutter and FutureBuilder'), findsOneWidget);
    expect(find.text('SharedPreferences Caching'), findsOneWidget);
  });
}
