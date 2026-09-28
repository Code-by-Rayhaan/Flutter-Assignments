import 'package:test/test.dart';
import '../lib/exceptions/api_exceptions.dart';
import '../lib/models/address.dart';
import '../lib/models/post.dart';
import '../lib/models/user_profile.dart';
import '../lib/services/mock_api_service.dart';

void main() {
  group('Model Serialization & Null Safety', () {
    test('Address handles nullable fields correctly', () {
      final json = {'street': '123 Main St', 'city': 'Metropolis'};
      final address = Address.fromJson(json);

      expect(address.street, '123 Main St');
      expect(address.city, 'Metropolis');
      expect(address.suite, isNull);
      expect(address.zipCode, isNull);
      expect(address.formattedAddress, '123 Main St, Metropolis');
    });

    test('UserProfile throws DataParsingException when required non-nullable field is missing', () {
      final invalidJson = {
        'id': 100,
        // 'name' missing
        'email': 'missing.name@example.com',
      };

      expect(
        () => UserProfile.fromJson(invalidJson),
        throwsA(isA<DataParsingException>()),
      );
    });

    test('UserProfile handles nullable bio and phone with fallback defaults', () {
      final json = {
        'id': 2,
        'name': 'Taylor Smith',
        'email': 'taylor@example.com',
        'bio': null,
        'avatarUrl': null,
        'phone': null,
        'address': null,
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.bioDisplay, 'No bio provided.');
      expect(profile.avatarDisplay, '[Default Silhouette Avatar]');
      expect(profile.maskedPhone, 'Not provided');
      expect(profile.addressDisplay, 'No address registered');
      expect(profile.interestsDisplay, 'None specified');
    });
  });

  group('MockApiService Asynchronous Operations & Error Handling', () {
    late MockApiService service;

    setUp(() {
      service = MockApiService();
    });

    test('fetchUserProfile succeeds for valid user ID 1', () async {
      final user = await service.fetchUserProfile(1, latency: Duration.zero);
      expect(user.id, 1);
      expect(user.name, 'Alex Johnson');
      expect(user.interests.length, greaterThan(0));
    });

    test('fetchUserProfile throws NotFoundException for non-existent user 404', () async {
      expect(
        () => service.fetchUserProfile(404, latency: Duration.zero),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('fetchUserProfile throws ServerException for user 500', () async {
      expect(
        () => service.fetchUserProfile(500, latency: Duration.zero),
        throwsA(isA<ServerException>()),
      );
    });

    test('fetchUserProfile throws NetworkException for user 503', () async {
      expect(
        () => service.fetchUserProfile(503, latency: Duration.zero),
        throwsA(isA<NetworkException>()),
      );
    });

    test('fetchUserProfile triggers ApiTimeoutException on timeout', () async {
      expect(
        () => service.fetchUserProfile(
          888,
          requestTimeout: const Duration(milliseconds: 50),
        ),
        throwsA(isA<ApiTimeoutException>()),
      );
    });

    test('fetchUserDashboard runs concurrently with Future.wait', () async {
      final (:user, :posts) = await service.fetchUserDashboard(1);
      expect(user.id, 1);
      expect(posts, isA<List<Post>>());
      expect(posts.isNotEmpty, isTrue);
    });
  });
}
