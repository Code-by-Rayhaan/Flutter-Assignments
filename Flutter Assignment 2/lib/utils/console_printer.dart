/// Utility class for formatted and colored console printing.
class ConsolePrinter {
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _cyan = '\x1B[36m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _magenta = '\x1B[35m';
  static const _gray = '\x1B[90m';

  static void printHeader(String title) {
    final border = '═' * (title.length + 8);
    print('\n$_cyan$_bold$border');
    print('  🚀 $title');
    print('$border$_reset\n');
  }

  static void printSection(int number, String title) {
    print('$_magenta$_bold════════════════════════════════════════════════════════════');
    print('  [Scenario $number] $title');
    print('════════════════════════════════════════════════════════════$_reset');
  }

  static void printSuccess(String message) {
    print('$_green$_bold  ✅ SUCCESS:$_reset $_green$message$_reset');
  }

  static void printWarning(String message) {
    print('$_yellow$_bold  ⚠️  HANDLED CASE:$_reset $_yellow$message$_reset');
  }

  static void printError(String message) {
    print('$_red$_bold  ❌ ERROR CAUGHT:$_reset $_red$message$_reset');
  }

  static void printInfo(String message) {
    print('$_gray  ℹ️  $message$_reset');
  }

  static void printDivider() {
    print('$_gray------------------------------------------------------------$_reset\n');
  }
}
