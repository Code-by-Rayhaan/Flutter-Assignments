import 'dart:async';
import '../exceptions/api_exceptions.dart';
import '../models/user_profile.dart';
import '../models/post.dart';

/// Simulates a REST API backend with realistic network latency,
/// varied data states (full, partial/null), and error conditions.
class MockApiService {
  // In-memory mock database representing server JSON responses
  static final Map<int, Map<String, dynamic>> _mockUserDatabase = {
    // 1. Full data record (all nullable fields present)
    1: {
      'id': 1,
      'name': 'Alex Johnson',
      'email': 'alex.johnson@example.com',
      'bio': 'Flutter & Dart enthusiast building clean cross-platform apps.',
      'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex',
      'phone': '+1 (555) 234-5678',
      'address': {
        'street': '742 Evergreen Terrace',
        'city': 'Springfield',
        'suite': 'Apt 4B',
        'zipCode': '97477',
      },
      'interests': ['Dart', 'Mobile Dev', 'Async Programming', 'UI/UX'],
    },

    // 2. Partial data record (nullable fields are null / empty)
    2: {
      'id': 2,
      'name': 'Taylor Smith',
      'email': 'taylor.smith@example.com',
      'bio': null, // Nullable string
      'avatarUrl': null, // Nullable string
      'phone': null, // Nullable string
      'address': null, // Nullable object
      'interests': null, // Nullable list (defaults to empty)
    },

    // 3. User with partial nested object
    3: {
      'id': 3,
      'name': 'Jordan Lee',
      'email': 'jordan.lee@example.com',
      'bio': 'Remote engineer & photographer.',
      'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jordan',
      'phone': '+1 (555) 987-6543',
      'address': {
        'street': '100 Innovation Way',
        'city': 'San Francisco',
        'suite': null,
        'zipCode': null,
      },
      'interests': ['Photography', 'AI', 'Open Source'],
    },

    // 999. Malformed data payload missing required non-nullable fields
    999: {
      'id': 999,
      // 'name' is missing entirely!
      'email': 'corrupted.data@example.com',
      'bio': 'Corrupted entry',
    },
  };

  static final Map<int, List<Map<String, dynamic>>> _mockPostsDatabase = {
    1: [
      {
        'id': 101,
        'userId': 1,
        'title': 'Mastering Futures and Streams in Dart',
        'body': 'Asynchronous programming is central to reactive Flutter UI updates.',
        'likesCount': 42,
        'publishedAt': '2026-09-15T10:30:00Z',
      },
      {
        'id': 102,
        'userId': 1,
        'title': 'Sound Null Safety Best Practices',
        'body': 'Never use the bang operator ! without a safety guard.',
        'likesCount': null, // Nullable field
        'publishedAt': '2026-09-20T14:15:00Z',
      },
    ],
    2: [
      {
        'id': 201,
        'userId': 2,
        'title': 'Hello World from a fresh profile!',
        'body': 'Starting my Dart journey today.',
        'likesCount': 5,
        'publishedAt': '2026-09-28T08:00:00Z',
      },
    ],
  };

  /// Fetches a [UserProfile] by [userId].
  ///
  /// Demonstrates:
  /// - `Future<UserProfile>` return type.
  /// - `async` / `await` syntax.
  /// - `Future.delayed` for simulating network latency.
  /// - Error handling for 404 (Not Found), 500 (Server Error), 503 (Network Error).
  /// - Custom timeout simulation.
  Future<UserProfile> fetchUserProfile(
    int userId, {
    Duration latency = const Duration(milliseconds: 600),
    Duration? requestTimeout,
  }) async {
    // Helper function that simulates the actual HTTP call
    Future<UserProfile> executeRequest() async {
      // 1. Simulate artificial network latency
      await Future.delayed(latency);

      // 2. Simulate specific test error conditions based on user ID
      if (userId == 500) {
        throw const ServerException(
          'Internal Server Error (500): Database cluster connection timed out.',
        );
      }

      if (userId == 503) {
        throw const NetworkException(
          'Network Connection Error (503): Unable to reach api.example.com host.',
        );
      }

      if (userId == 888) {
        // Slow response to trigger timeout if caller sets a shorter duration
        await Future.delayed(const Duration(seconds: 3));
      }

      // 3. Check if user exists in mock DB
      final rawData = _mockUserDatabase[userId];
      if (rawData == null) {
        throw NotFoundException('User with ID $userId');
      }

      // 4. Parse and return model (can throw DataParsingException)
      return UserProfile.fromJson(rawData);
    }

    // If a requestTimeout is provided, wrap with Future.timeout
    if (requestTimeout != null) {
      try {
        return await executeRequest().timeout(
          requestTimeout,
          onTimeout: () => throw ApiTimeoutException(requestTimeout),
        );
      } on TimeoutException {
        throw ApiTimeoutException(requestTimeout);
      }
    }

    return await executeRequest();
  }

  /// Fetches the list of posts for a given [userId].
  Future<List<Post>> fetchUserPosts(
    int userId, {
    Duration latency = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(latency);

    // If user is 500 or 503, throw appropriate error
    if (userId == 500) throw const ServerException();
    if (userId == 503) throw const NetworkException();

    final postsJson = _mockPostsDatabase[userId] ?? <Map<String, dynamic>>[];
    return postsJson.map((json) => Post.fromJson(json)).toList();
  }

  /// Demonstrates concurrent fetching of user profile and posts
  /// using `Future.wait` to optimize total load time.
  Future<({UserProfile user, List<Post> posts})> fetchUserDashboard(
    int userId,
  ) async {
    // Run both asynchronous operations in parallel
    final results = await Future.wait([
      fetchUserProfile(userId),
      fetchUserPosts(userId),
    ]);

    final user = results[0] as UserProfile;
    final posts = results[1] as List<Post>;

    return (user: user, posts: posts);
  }
}
