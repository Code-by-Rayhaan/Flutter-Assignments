# Simple Library Management System (Dart Console Application)

This project models a simple Library System in Dart, demonstrating the core principles of Dart programming including **variables**, **loops**, **functions**, and **Object-Oriented Programming (OOP) with inheritance**.

---

## 🚀 Key Concepts Covered

1. **Variables & Data Types**:
   - Primitive types: `String`, `int`, `double`, `bool`.
   - Collections: `List<LibraryItem>`, `List<Member>`.
   - Modifiers: `final`, private variables (e.g. `_isAvailable`, `_borrowedItems`).

2. **Object-Oriented Programming (OOP) & Inheritance**:
   - **Base Abstract Class**: [`LibraryItem`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L4-L34)
     - Encapsulation with private field `_isAvailable` and public getter `isAvailable`.
     - Common methods: `borrowItem()`, `returnItem()`, abstract `displayInfo()`.
   - **Inheritance & Subclasses**:
     - [`Book`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L37-L61) (extends `LibraryItem` with `author`, `genre`, `pageCount`)
     - [`Magazine`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L64-L86) (extends `LibraryItem` with `issueNumber`, `publisher`)
     - [`AudioBook`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L89-L111) (extends `LibraryItem` with `narrator`, `durationInHours`)
   - **Polymorphism**:
     - Overriding `displayInfo()` in each subclass to format item-specific information.
   - **Composition**:
     - [`Member`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L114-L151) holding a list of borrowed `LibraryItem` objects.
     - [`Library`](file:///Users/rayhaansiledar/Desktop/Flutter%20Assignment%201/main.dart#L154-L232) managing collections of items and members.

3. **Loops**:
   - `while` loop for the interactive console menu and search iteration.
   - `for-in` loop for iterating through inventory and member collections.
   - Standard `for` loop with index tracking for enumerated displays.

4. **Functions**:
   - Modular functions with named and positional parameters (`addNewItemPrompt`, `seedInitialData`, `runAutomatedDemo`).
   - Higher-order functions: `.where()`, `.firstWhere()`, `.map()`.

---

## 💻 How to Run

Run the program from your terminal:

```bash
dart run main.dart
```
