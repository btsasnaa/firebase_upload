class MyMVCModel {
  static int _counter = 0;
  int get counter => _counter;

  static int incrementCounter() => ++_counter;
  static int decrementCounter() => --_counter;
}
