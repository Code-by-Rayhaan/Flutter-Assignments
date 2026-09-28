import 'dart:async';
import '../lib/exceptions/api_exceptions.dart';
import '../lib/models/user_profile.dart';
import '../lib/services/mock_api_service.dart';
import '../lib/utils/console_printer.dart';

/// Main entry point for the Dart Async & Null Safety demonstration program.
void main() async {
  ConsolePrinter.printHeader('Dart Null Safety, Futures & Async/Await Showcase');

  final apiService = MockApiService();

  // ---------------------------------------------------------------------------
  // SCENARIO 1: Happy Path - Fetching Full Data Record
  // ---------------------------------------------------------------------------
  await runScenario1(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 2: Null Safety in Action - Handling Null & Missing Fields Gracefully
  // ---------------------------------------------------------------------------
  await runScenario2(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 3: Parallel Asynchronous Execution with Future.wait & Records
  // ---------------------------------------------------------------------------
  await runScenario3(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 4: 404 Not Found Exception Handling
  // ---------------------------------------------------------------------------
  await runScenario4(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 5: 500 Internal Server Error Handling
  // ---------------------------------------------------------------------------
  await runScenario5(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 6: 503 Network / Connectivity Failure Handling
  // ---------------------------------------------------------------------------
  await runScenario6(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 7: Data Parsing / Schema Validation Failure (Missing Required Fields)
  // ---------------------------------------------------------------------------
  await runScenario7(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 8: Asynchronous Request Timeout (Future.timeout)
  // ---------------------------------------------------------------------------
  await runScenario8(apiService);

  // ---------------------------------------------------------------------------
  // SCENARIO 9: Null Coalescing Assignment (??=) and Default Fallbacks
  // ---------------------------------------------------------------------------
  runScenario9();

  print('\n🎯 All 9 Scenarios executed successfully! Program finished.\n');
}

/// Scenario 1: Fetching full user profile with all fields populated
Future<void> runScenario1(MockApiService apiService) async {
  ConsolePrinter.printSection(1, 'Happy Path: Fetch User Profile with Complete Data (User ID 1)');
  ConsolePrinter.printInfo('Fetching user 1 asynchronously using await apiService.fetchUserProfile(1)...');

  try {
    final stopwatch = Stopwatch()..start();
    final UserProfile profile = await apiService.fetchUserProfile(1);
    stopwatch.stop();

    ConsolePrinter.printSuccess('User profile fetched in ${stopwatch.elapsedMilliseconds}ms:');
    print(profile.toDetailedString());
  } on ApiException catch (e) {
    ConsolePrinter.printError('API Error: ${e.message}');
  } catch (e) {
    ConsolePrinter.printError('Unexpected error: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 1 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 2: Handling null fields with null-coalescing and safe navigation
Future<void> runScenario2(MockApiService apiService) async {
  ConsolePrinter.printSection(2, 'Null Safety: Partial Data with Nullable Fields (User ID 2)');
  ConsolePrinter.printInfo('User 2 has null bio, null avatar, null phone, and null address.');

  try {
    final UserProfile profile = await apiService.fetchUserProfile(2);

    ConsolePrinter.printSuccess('User profile fetched successfully with null-safe fallbacks:');
    print(profile.toDetailedString());

    // Explicit demonstrations of Dart Null Safety Operators:
    print('\n  🔍 Null Safety Operators Demonstration:');

    // 1. Safe navigation (?.) and Null Coalescing (??)
    final String safeCity = profile.address?.city ?? 'Default: Earth';
    print('  • Safe Navigation (?.) + Fallback (??): Address City -> "$safeCity"');

    // 2. Checking null condition
    final bool hasBio = profile.bio != null;
    print('  • Null Check (profile.bio != null): $hasBio');

    // 3. String interpolation with fallback
    final String contactInfo = profile.phone ?? 'No phone number registered';
    print('  • Null-Coalescing (??): Phone -> "$contactInfo"');
  } on ApiException catch (e) {
    ConsolePrinter.printError('API Error: ${e.message}');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 2 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 3: Concurrently fetching user profile and posts with Future.wait
Future<void> runScenario3(MockApiService apiService) async {
  ConsolePrinter.printSection(3, 'Concurrent Async: Future.wait for Parallel API Requests');
  ConsolePrinter.printInfo('Fetching UserProfile and UserPosts in parallel for User ID 1...');

  try {
    final stopwatch = Stopwatch()..start();

    // Fetch user and posts concurrently
    final (:user, :posts) = await apiService.fetchUserDashboard(1);
    stopwatch.stop();

    ConsolePrinter.printSuccess(
      'Fetched User and ${posts.length} Posts in parallel (${stopwatch.elapsedMilliseconds}ms):',
    );
    print('  👤 User: ${user.name} (${user.email})');
    print('  📝 Published Posts:');
    if (posts.isEmpty) {
      print('     No posts found for this user.');
    } else {
      for (final post in posts) {
        print('     • ${post.displaySummary}');
        print('       "${post.body}"');
      }
    }
  } on ApiException catch (e) {
    ConsolePrinter.printError('Dashboard API Error: ${e.message}');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 3 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 4: Error Handling - 404 Resource Not Found
Future<void> runScenario4(MockApiService apiService) async {
  ConsolePrinter.printSection(4, 'Error Handling: 404 Resource Not Found (User ID 404)');
  ConsolePrinter.printInfo('Attempting to fetch non-existent User ID 404...');

  try {
    final profile = await apiService.fetchUserProfile(404);
    print('User: $profile');
  } on NotFoundException catch (e) {
    ConsolePrinter.printWarning('Caught Expected NotFoundException!');
    print('  Status Code: ${e.statusCode}');
    print('  Error Message: ${e.message}');
  } on ApiException catch (e) {
    ConsolePrinter.printError('Generic API Exception: $e');
  } catch (e) {
    ConsolePrinter.printError('Unexpected exception: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 4 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 5: Error Handling - 500 Server Error
Future<void> runScenario5(MockApiService apiService) async {
  ConsolePrinter.printSection(5, 'Error Handling: 500 Internal Server Error (User ID 500)');
  ConsolePrinter.printInfo('Triggering simulated 500 database failure on backend...');

  try {
    await apiService.fetchUserProfile(500);
  } on ServerException catch (e) {
    ConsolePrinter.printWarning('Caught Expected ServerException!');
    print('  Status Code: ${e.statusCode}');
    print('  Error Message: ${e.message}');
  } on ApiException catch (e) {
    ConsolePrinter.printError('Generic API Exception: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 5 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 6: Error Handling - 503 Network / Connectivity Error
Future<void> runScenario6(MockApiService apiService) async {
  ConsolePrinter.printSection(6, 'Error Handling: 503 Network Connectivity Error (User ID 503)');
  ConsolePrinter.printInfo('Triggering simulated socket/network dropped connection...');

  try {
    await apiService.fetchUserProfile(503);
  } on NetworkException catch (e) {
    ConsolePrinter.printWarning('Caught Expected NetworkException!');
    print('  Status Code: ${e.statusCode}');
    print('  Error Message: ${e.message}');
  } on ApiException catch (e) {
    ConsolePrinter.printError('Generic API Exception: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 6 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 7: Data Integrity - Missing Required Fields (DataParsingException)
Future<void> runScenario7(MockApiService apiService) async {
  ConsolePrinter.printSection(7, 'Null Safety & Validation: Missing Non-Nullable Fields (User ID 999)');
  ConsolePrinter.printInfo('Backend returns JSON with missing non-nullable "name" field...');

  try {
    await apiService.fetchUserProfile(999);
  } on DataParsingException catch (e) {
    ConsolePrinter.printWarning('Caught Expected DataParsingException due to null-safety violation!');
    print('  Offending Field: ${e.fieldName}');
    print('  Error Message: ${e.message}');
  } on ApiException catch (e) {
    ConsolePrinter.printError('Generic API Exception: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 7 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 8: Async Timeouts - Handling Slow API Responses
Future<void> runScenario8(MockApiService apiService) async {
  ConsolePrinter.printSection(8, 'Async Timeout: Request Exceeds Threshold (User ID 888)');
  ConsolePrinter.printInfo('User 888 takes 3.0s to respond, but client timeout is set to 1.0s...');

  try {
    await apiService.fetchUserProfile(
      888,
      requestTimeout: const Duration(seconds: 1),
    );
  } on ApiTimeoutException catch (e) {
    ConsolePrinter.printWarning('Caught Expected ApiTimeoutException!');
    print('  Timeout Duration: ${e.duration.inSeconds}s');
    print('  Error Message: ${e.message}');
  } on ApiException catch (e) {
    ConsolePrinter.printError('Generic API Exception: $e');
  } finally {
    ConsolePrinter.printInfo('[finally] Scenario 8 request completed.');
    ConsolePrinter.printDivider();
  }
}

/// Scenario 9: Null Coalescing Assignment (??=) and Local Null-Safe Operations
void runScenario9() {
  ConsolePrinter.printSection(9, 'Null-Coalescing Assignment (??=) & Flow Analysis');

  String? getUserSessionToken(String? existingToken) {
    var token = existingToken;
    token ??= 'generated_default_token_${DateTime.now().millisecondsSinceEpoch}';
    return token;
  }

  final token1 = getUserSessionToken(null);
  print('  • Fallback generated token for null input: $token1');

  final token2 = getUserSessionToken('existing_custom_token_999');
  print('  • Retained token for existing input: $token2');

  // Type Promotion with Flow Analysis
  final Object? dynamicData = 'Flutter Dart Assignment';
  if (dynamicData is String) {
    // dynamicData is automatically promoted to String here
    print('  • Type Promoted string length: ${dynamicData.length}');
  }

  ConsolePrinter.printSuccess('Null-coalescing assignment and type promotion tested.');
  ConsolePrinter.printDivider();
}
