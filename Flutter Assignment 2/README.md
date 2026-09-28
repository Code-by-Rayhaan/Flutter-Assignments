# Dart Asynchronous Programming & Null Safety Showcase

A Dart program demonstrating **Sound Null Safety**, **Futures**, **async / await**, parallel execution with `Future.wait`, custom exception handling, and robust data modeling with mock API scenarios.

---

## 🚀 Key Concepts Demonstrated

### 1. Sound Null Safety
- **Non-nullable vs. Nullable Types**: `String` vs `String?`, `int` vs `int?`, `Address?`.
- **Null-Aware Operators**:
  - Safe navigation: `profile.address?.city`
  - Null-coalescing fallback: `profile.bio ?? 'No bio provided.'`
  - Null-coalescing assignment: `token ??= generateDefaultToken()`
  - Null-guarded assertion / promotion: flow analysis automatically promoting nullable types when null-checked (`if (profile.bio != null)`).
- **Safe JSON Deserialization**: Strict validation throwing typed `DataParsingException` when mandatory non-nullable fields are missing or corrupted.

### 2. Asynchronous Programming (`Future`, `async` & `await`)
- **Simulated Latency**: Using `Future.delayed` to emulate realistic network delays.
- **Sequential Execution**: Awaiting asynchronous operations in a clear, readable linear flow.
- **Concurrent Execution**: Utilizing `Future.wait` and Dart 3 records `(:user, :posts)` to fetch user profile and posts simultaneously.
- **Request Timeouts**: Using `.timeout()` to enforce response time limits and catch slow connections.

### 3. Comprehensive Error & Exception Handling
- Custom exception hierarchy:
  - `NotFoundException` (404 Resource Not Found)
  - `ServerException` (500 Internal Server Error)
  - `NetworkException` (503 Network / Connectivity Failure)
  - `DataParsingException` (422 Schema / Missing Non-Nullable Fields)
  - `ApiTimeoutException` (408 Request Timeout)
- Granular `try / on SpecificException / catch / finally` handling blocks.

---

## 📂 Project Structure

```
.
├── pubspec.yaml
├── bin/
│   └── main.dart                     # Application runner covering 9 end-to-end scenarios
├── lib/
│   ├── exceptions/
│   │   └── api_exceptions.dart       # Custom typed API exceptions hierarchy
│   ├── models/
│   │   ├── address.dart              # Address model with nullable fields
│   │   ├── post.dart                 # Post model with null-safe JSON parsing
│   │   └── user_profile.dart         # UserProfile model demonstrating null-aware operators
│   ├── services/
│   │   └── mock_api_service.dart     # Mock API service with latency, timeouts & error states
│   └── utils/
│       └── console_printer.dart      # Rich terminal styling & formatted console output
└── test/
    └── api_service_test.dart         # Unit test suite for models, async flow & errors
```

---

## 🧪 Scenarios Covered in `bin/main.dart`

| Scenario | Focus Area | Description |
| :--- | :--- | :--- |
| **1** | Happy Path | Fetch complete user data record (ID: 1) with all fields present |
| **2** | Null Handling | Fetch record with null fields (ID: 2) and display safe defaults |
| **3** | Parallel Async | Concurrently fetch profile + posts using `Future.wait` |
| **4** | 404 Not Found | Catch `NotFoundException` when user ID does not exist |
| **5** | 500 Server Error | Catch `ServerException` on backend failure |
| **6** | 503 Network Error| Catch `NetworkException` on connectivity loss |
| **7** | Schema Validation| Catch `DataParsingException` when non-nullable fields are missing |
| **8** | Async Timeout | Catch `ApiTimeoutException` when request duration exceeds limit |
| **9** | Flow Analysis | Test null-coalescing assignment (`??=`) and type promotion |

---

## 💻 How to Run

### 1. Run the Main Program
```bash
dart run bin/main.dart
```

### 2. Run the Unit Test Suite
```bash
dart test
```

### 3. Run Static Code Analysis
```bash
dart analyze
```
