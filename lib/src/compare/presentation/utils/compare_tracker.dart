class CompareTracker {
  static int _compareCount = 0;

  static int get count => _compareCount;

  static void increment() {
    _compareCount++;
  }

  static void reset() {
    _compareCount = 0;
  }
}