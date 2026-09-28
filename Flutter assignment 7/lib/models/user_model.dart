/// Represents the registered user's submitted data.
class UserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String accountType;
  final bool subscribedToNewsletter;
  final DateTime registeredAt;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.accountType,
    this.subscribedToNewsletter = false,
    required this.registeredAt,
  });

  /// Formatted date string for user-friendly display.
  String get formattedRegistrationDate {
    final year = registeredAt.year;
    final month = registeredAt.month.toString().padLeft(2, '0');
    final day = registeredAt.day.toString().padLeft(2, '0');
    final hour = registeredAt.hour.toString().padLeft(2, '0');
    final minute = registeredAt.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  /// Initials derived from the full name for avatar display.
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
