import 'package:flutter_assignment_8/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Post Model Tests', () {
    test('Post.fromJson parses JSON map correctly', () {
      final json = {
        'id': 101,
        'userId': 5,
        'title': 'Test Post Title',
        'body': 'This is a test post body.',
      };

      final post = Post.fromJson(json);

      expect(post.id, 101);
      expect(post.userId, 5);
      expect(post.title, 'Test Post Title');
      expect(post.body, 'This is a test post body.');
    });

    test('Post.toJson creates correct map', () {
      const post = Post(
        id: 42,
        userId: 3,
        title: 'Another Title',
        body: 'Another Body',
      );

      final json = post.toJson();

      expect(json['id'], 42);
      expect(json['userId'], 3);
      expect(json['title'], 'Another Title');
      expect(json['body'], 'Another Body');
    });

    test('Post encodeList and decodeList handles list serialization', () {
      final posts = [
        const Post(id: 1, userId: 1, title: 'Title 1', body: 'Body 1'),
        const Post(id: 2, userId: 1, title: 'Title 2', body: 'Body 2'),
      ];

      final encoded = Post.encodeList(posts);
      final decoded = Post.decodeList(encoded);

      expect(decoded.length, 2);
      expect(decoded[0].id, 1);
      expect(decoded[0].title, 'Title 1');
      expect(decoded[1].id, 2);
      expect(decoded[1].body, 'Body 2');
    });
  });
}
