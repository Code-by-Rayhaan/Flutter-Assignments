import '../exceptions/api_exceptions.dart';
import 'address.dart';

/// Represents a comprehensive user profile demonstrating sound null safety.
class UserProfile {
  // Non-nullable required fields
  final int id;
  final String name;
  final String email;

  // Nullable optional fields
  final String? bio;
  final String? avatarUrl;
  final String? phone;
  final Address? address;

  // Non-nullable field with collection
  final List<String> interests;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.phone,
    this.address,
    this.interests = const <String>[],
  });

  /// Factory constructor to deserialize JSON into a UserProfile instance.
  /// Throws [DataParsingException] if non-nullable constraints are violated.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // 1. Safe extraction of required fields
    final id = json['id'] as int?;
    final name = json['name'] as String?;
    final email = json['email'] as String?;

    // Validate non-nullable fields
    if (id == null) {
      throw const DataParsingException('User ID is required and cannot be null', 'id');
    }
    if (name == null || name.trim().isEmpty) {
      throw const DataParsingException('User name is required and cannot be empty', 'name');
    }
    if (email == null || !email.contains('@')) {
      throw const DataParsingException('Valid email is required', 'email');
    }

    // 2. Safe extraction of nullable fields
    final bio = json['bio'] as String?;
    final avatarUrl = json['avatarUrl'] as String?;
    final phone = json['phone'] as String?;

    // 3. Safe extraction of nested nullable object
    Address? address;
    if (json['address'] != null && json['address'] is Map<String, dynamic>) {
      address = Address.fromJson(json['address'] as Map<String, dynamic>);
    }

    // 4. Safe collection conversion with null fallback
    final rawInterests = json['interests'] as List<dynamic>?;
    final interests = rawInterests
            ?.map((e) => e.toString())
            .where((tag) => tag.isNotEmpty)
            .toList() ??
        <String>[];

    return UserProfile(
      id: id,
      name: name,
      email: email,
      bio: bio,
      avatarUrl: avatarUrl,
      phone: phone,
      address: address,
      interests: interests,
    );
  }

  // --- Null Safety Demonstration Helper Getters ---

  /// Uses null-coalescing (??) operator to provide a fallback description.
  String get bioDisplay => bio?.trim().isNotEmpty == true ? bio! : 'No bio provided.';

  /// Uses safe navigation (?.) and null assertion (!) when guarded.
  String get avatarDisplay =>
      (avatarUrl != null && avatarUrl!.startsWith('http'))
          ? avatarUrl!
          : '[Default Silhouette Avatar]';

  /// Masks phone number if available, otherwise returns fallback.
  String get maskedPhone {
    final rawPhone = phone;
    if (rawPhone == null || rawPhone.isEmpty) {
      return 'Not provided';
    }
    // Mask all digits except the last 4
    return rawPhone.replaceAll(RegExp(r'\d(?=\d{4})'), '*');
  }

  /// Safely accesses nested object property with fallback.
  String get addressDisplay => address?.formattedAddress ?? 'No address registered';

  /// Formatted interests list.
  String get interestsDisplay =>
      interests.isEmpty ? 'None specified' : interests.join(', ');

  /// Pretty printable summary of the user profile.
  String toDetailedString() {
    return '''
  👤 User Profile (ID: $id)
  ├─ Name:      $name
  ├─ Email:     $email
  ├─ Phone:     $maskedPhone
  ├─ Bio:       $bioDisplay
  ├─ Avatar:    $avatarDisplay
  ├─ Address:   $addressDisplay
  └─ Interests: $interestsDisplay''';
  }

  @override
  String toString() => 'UserProfile(id: $id, name: "$name", email: "$email")';
}
