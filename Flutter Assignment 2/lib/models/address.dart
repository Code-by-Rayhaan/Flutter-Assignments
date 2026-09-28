import '../exceptions/api_exceptions.dart';

/// Represents a user's physical address with optional nullable fields.
class Address {
  final String street;
  final String city;
  final String? suite;
  final String? zipCode;

  const Address({
    required this.street,
    required this.city,
    this.suite,
    this.zipCode,
  });

  /// Factory constructor parsing JSON map with null safety checks.
  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const DataParsingException('Address data cannot be null');
    }

    final street = json['street'] as String?;
    final city = json['city'] as String?;

    // Validate non-nullable required fields
    if (street == null || street.trim().isEmpty) {
      throw const DataParsingException('Street is required and cannot be null/empty', 'street');
    }
    if (city == null || city.trim().isEmpty) {
      throw const DataParsingException('City is required and cannot be null/empty', 'city');
    }

    return Address(
      street: street,
      city: city,
      suite: json['suite'] as String?, // Nullable
      zipCode: json['zipCode'] as String?, // Nullable
    );
  }

  /// Returns a formatted full address string using null-coalescing and safe navigation.
  String get formattedAddress {
    final buffer = StringBuffer(street);
    if (suite != null && suite!.isNotEmpty) {
      buffer.write(', Suite: $suite');
    }
    buffer.write(', $city');
    if (zipCode != null && zipCode!.isNotEmpty) {
      buffer.write(' ($zipCode)');
    }
    return buffer.toString();
  }

  @override
  String toString() => formattedAddress;
}
