import 'dart:io';

/// Base class representing a general library item
abstract class LibraryItem {
  final String id;
  final String title;
  final int publicationYear;
  bool _isAvailable;

  LibraryItem({
    required this.id,
    required this.title,
    required this.publicationYear,
    bool isAvailable = true,
  }) : _isAvailable = isAvailable;

  // Getter for availability
  bool get isAvailable => _isAvailable;

  // Method to borrow item
  bool borrowItem() {
    if (_isAvailable) {
      _isAvailable = false;
      return true;
    }
    return false;
  }

  // Method to return item
  void returnItem() {
    _isAvailable = true;
  }

  // Polymorphic display method to be overridden by subclasses
  void displayInfo();
}

/// Subclass: Book (Inherits from LibraryItem)
class Book extends LibraryItem {
  final String author;
  final String genre;
  final int pageCount;

  Book({
    required String id,
    required String title,
    required int publicationYear,
    required this.author,
    required this.genre,
    required this.pageCount,
    bool isAvailable = true,
  }) : super(
          id: id,
          title: title,
          publicationYear: publicationYear,
          isAvailable: isAvailable,
        );

  @override
  void displayInfo() {
    final String status = isAvailable ? 'Available' : 'Borrowed';
    print('[Book] ID: $id | "$title" by $author | Genre: $genre | Pages: $pageCount | Year: $publicationYear | Status: $status');
  }
}

/// Subclass: Magazine (Inherits from LibraryItem)
class Magazine extends LibraryItem {
  final int issueNumber;
  final String publisher;

  Magazine({
    required String id,
    required String title,
    required int publicationYear,
    required this.issueNumber,
    required this.publisher,
    bool isAvailable = true,
  }) : super(
          id: id,
          title: title,
          publicationYear: publicationYear,
          isAvailable: isAvailable,
        );

  @override
  void displayInfo() {
    final String status = isAvailable ? 'Available' : 'Borrowed';
    print('[Magazine] ID: $id | "$title" (Issue #$issueNumber) | Publisher: $publisher | Year: $publicationYear | Status: $status');
  }
}

/// Subclass: AudioBook (Inherits from LibraryItem)
class AudioBook extends LibraryItem {
  final String narrator;
  final double durationInHours;

  AudioBook({
    required String id,
    required String title,
    required int publicationYear,
    required this.narrator,
    required this.durationInHours,
    bool isAvailable = true,
  }) : super(
          id: id,
          title: title,
          publicationYear: publicationYear,
          isAvailable: isAvailable,
        );

  @override
  void displayInfo() {
    final String status = isAvailable ? 'Available' : 'Borrowed';
    print('[AudioBook] ID: $id | "$title" | Narrator: $narrator | Duration: ${durationInHours}h | Year: $publicationYear | Status: $status');
  }
}

/// Member class representing a library user
class Member {
  final String memberId;
  final String name;
  final List<LibraryItem> _borrowedItems = [];

  Member({required this.memberId, required this.name});

  List<LibraryItem> get borrowedItems => List.unmodifiable(_borrowedItems);

  void borrow(LibraryItem item) {
    if (item.borrowItem()) {
      _borrowedItems.add(item);
      print('✓ "$name" successfully borrowed "${item.title}".');
    } else {
      print('✗ Sorry, "${item.title}" is currently not available.');
    }
  }

  void returnBorrowedItem(LibraryItem item) {
    if (_borrowedItems.remove(item)) {
      item.returnItem();
      print('✓ "$name" successfully returned "${item.title}".');
    } else {
      print('✗ "$name" does not have "${item.title}" borrowed.');
    }
  }

  void displayMemberInfo() {
    print('---------------------------------------------');
    print('Member ID: $memberId | Name: $name');
    if (_borrowedItems.isEmpty) {
      print('  No items currently borrowed.');
    } else {
      print('  Borrowed Items (${_borrowedItems.length}):');
      for (var item in _borrowedItems) {
        print('   - [${item.id}] ${item.title}');
      }
    }
  }
}

/// Library class managing the collection of items and members
class Library {
  final String name;
  final List<LibraryItem> _items = [];
  final List<Member> _members = [];

  Library({required this.name});

  // Add items
  void addItem(LibraryItem item) {
    _items.add(item);
  }

  // Register members
  void registerMember(Member member) {
    _members.add(member);
  }

  // Find item by ID
  LibraryItem? findItemById(String id) {
    try {
      return _items.firstWhere(
        (item) => item.id.toLowerCase() == id.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // Find member by ID
  Member? findMemberById(String id) {
    try {
      return _members.firstWhere(
        (m) => m.memberId.toLowerCase() == id.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // Display all items (Demonstrating for-in loop & polymorphism)
  void displayAllItems() {
    print('\n================ $name Inventory ================');
    if (_items.isEmpty) {
      print('Inventory is empty.');
      return;
    }
    for (var item in _items) {
      item.displayInfo();
    }
    print('======================================================');
  }

  // Display available items (Demonstrating higher order functions and loops)
  void displayAvailableItems() {
    print('\nAvailable Items:');
    final availableItems = _items.where((item) => item.isAvailable).toList();
    if (availableItems.isEmpty) {
      print('No items are currently available.');
      return;
    }
    for (int i = 0; i < availableItems.length; i++) {
      print('${i + 1}. [${availableItems[i].id}] ${availableItems[i].title}');
    }
  }

  // Search items (Demonstrating while loop / filtering)
  void searchItems(String query) {
    print('\nSearch results for "$query":');
    final queryLower = query.toLowerCase();
    final results = _items.where((item) => item.title.toLowerCase().contains(queryLower)).toList();

    if (results.isEmpty) {
      print('No items found matching "$query".');
      return;
    }

    int index = 0;
    while (index < results.length) {
      results[index].displayInfo();
      index++;
    }
  }

  // Display all registered members
  void displayAllMembers() {
    print('\n================ Registered Members ================');
    if (_members.isEmpty) {
      print('No members registered.');
      return;
    }
    for (var member in _members) {
      member.displayMemberInfo();
    }
    print('---------------------------------------------');
  }
}

/// Helper function to seed initial data
void seedInitialData(Library library) {
  // Books
  library.addItem(Book(
    id: 'B001',
    title: 'Clean Code',
    publicationYear: 2008,
    author: 'Robert C. Martin',
    genre: 'Software Engineering',
    pageCount: 464,
  ));
  library.addItem(Book(
    id: 'B002',
    title: 'The Pragmatic Programmer',
    publicationYear: 1999,
    author: 'Andrew Hunt & David Thomas',
    genre: 'Programming',
    pageCount: 352,
  ));

  // Magazines
  library.addItem(Magazine(
    id: 'M001',
    title: 'National Geographic',
    publicationYear: 2024,
    issueNumber: 312,
    publisher: 'National Geographic Partners',
  ));

  // AudioBooks
  library.addItem(AudioBook(
    id: 'A001',
    title: 'Atomic Habits',
    publicationYear: 2018,
    narrator: 'James Clear',
    durationInHours: 5.5,
  ));

  // Members
  library.registerMember(Member(memberId: 'U001', name: 'Alice Smith'));
  library.registerMember(Member(memberId: 'U002', name: 'Bob Johnson'));
}

/// Function to run a quick automated demonstration
void runAutomatedDemo(Library library) {
  print('\n=== Running Automated Demonstration ===\n');

  final member = library.findMemberById('U001');
  final book = library.findItemById('B001');
  final audioBook = library.findItemById('A001');

  if (member != null && book != null && audioBook != null) {
    print('1. Alice borrows "Clean Code":');
    member.borrow(book);

    print('\n2. Attempting to borrow "Clean Code" again:');
    final member2 = library.findMemberById('U002');
    member2?.borrow(book);

    print('\n3. Alice borrows "Atomic Habits" audiobook:');
    member.borrow(audioBook);

    print('\n4. Updated Member Info:');
    member.displayMemberInfo();

    print('\n5. Alice returns "Clean Code":');
    member.returnBorrowedItem(book);

    print('\n6. Inventory Status after return:');
    book.displayInfo();
  }
  print('\n=== Automated Demonstration Finished ===\n');
}

/// Main entry point with interactive console menu
void main() {
  final library = Library(name: 'City Central Library');
  seedInitialData(library);

  print('====================================================');
  print('     Welcome to ${library.name} Management System    ');
  print('====================================================');

  bool isRunning = true;

  // Main interactive menu loop
  while (isRunning) {
    print('\nPlease select an option:');
    print('1. View All Library Items (Catalog)');
    print('2. View Available Items Only');
    print('3. Search Items by Title');
    print('4. Borrow an Item');
    print('5. Return an Item');
    print('6. View Registered Members');
    print('7. Add a New Book / Magazine / AudioBook');
    print('8. Run Automated Demonstration');
    print('9. Exit');
    stdout.write('\nEnter choice (1-9): ');

    final input = stdin.readLineSync()?.trim();

    switch (input) {
      case '1':
        library.displayAllItems();
        break;

      case '2':
        library.displayAvailableItems();
        break;

      case '3':
        stdout.write('Enter search keyword: ');
        final query = stdin.readLineSync()?.trim() ?? '';
        library.searchItems(query);
        break;

      case '4':
        stdout.write('Enter Member ID (e.g. U001, U002): ');
        final memberId = stdin.readLineSync()?.trim() ?? '';
        final member = library.findMemberById(memberId);

        if (member == null) {
          print('✗ Member not found with ID: $memberId');
          break;
        }

        stdout.write('Enter Item ID to borrow (e.g. B001, M001, A001): ');
        final itemId = stdin.readLineSync()?.trim() ?? '';
        final item = library.findItemById(itemId);

        if (item == null) {
          print('✗ Item not found with ID: $itemId');
          break;
        }

        member.borrow(item);
        break;

      case '5':
        stdout.write('Enter Member ID (e.g. U001, U002): ');
        final memberId = stdin.readLineSync()?.trim() ?? '';
        final member = library.findMemberById(memberId);

        if (member == null) {
          print('✗ Member not found with ID: $memberId');
          break;
        }

        stdout.write('Enter Item ID to return: ');
        final itemId = stdin.readLineSync()?.trim() ?? '';
        final item = library.findItemById(itemId);

        if (item == null) {
          print('✗ Item not found with ID: $itemId');
          break;
        }

        member.returnBorrowedItem(item);
        break;

      case '6':
        library.displayAllMembers();
        break;

      case '7':
        addNewItemPrompt(library);
        break;

      case '8':
        runAutomatedDemo(library);
        break;

      case '9':
        print('\nThank you for using ${library.name} System. Goodbye!\n');
        isRunning = false;
        break;

      default:
        print('Invalid option. Please enter a number between 1 and 9.');
        break;
    }
  }
}

/// Helper function to prompt and add new items
void addNewItemPrompt(Library library) {
  print('\nSelect Item Type to Add:');
  print('1. Book');
  print('2. Magazine');
  print('3. AudioBook');
  stdout.write('Enter type (1-3): ');
  final typeChoice = stdin.readLineSync()?.trim();

  stdout.write('Enter ID: ');
  final id = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Enter Title: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Enter Publication Year: ');
  final year = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? DateTime.now().year;

  if (typeChoice == '1') {
    stdout.write('Enter Author: ');
    final author = stdin.readLineSync()?.trim() ?? 'Unknown';
    stdout.write('Enter Genre: ');
    final genre = stdin.readLineSync()?.trim() ?? 'General';
    stdout.write('Enter Page Count: ');
    final pages = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 100;

    library.addItem(Book(
      id: id,
      title: title,
      publicationYear: year,
      author: author,
      genre: genre,
      pageCount: pages,
    ));
    print('✓ Book "$title" added successfully!');
  } else if (typeChoice == '2') {
    stdout.write('Enter Issue Number: ');
    final issueNum = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 1;
    stdout.write('Enter Publisher: ');
    final publisher = stdin.readLineSync()?.trim() ?? 'Unknown Publisher';

    library.addItem(Magazine(
      id: id,
      title: title,
      publicationYear: year,
      issueNumber: issueNum,
      publisher: publisher,
    ));
    print('✓ Magazine "$title" added successfully!');
  } else if (typeChoice == '3') {
    stdout.write('Enter Narrator: ');
    final narrator = stdin.readLineSync()?.trim() ?? 'Unknown';
    stdout.write('Enter Duration (hours): ');
    final duration = double.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 1.0;

    library.addItem(AudioBook(
      id: id,
      title: title,
      publicationYear: year,
      narrator: narrator,
      durationInHours: duration,
    ));
    print('✓ AudioBook "$title" added successfully!');
  } else {
    print('Invalid item type selected.');
  }
}
