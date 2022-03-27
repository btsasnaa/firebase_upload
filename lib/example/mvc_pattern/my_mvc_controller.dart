import 'package:firebase_upload/example/mvc_pattern/my_mvc_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MyMVCController extends ControllerMVC {
  factory MyMVCController() {
    if (_this == null) _this = MyMVCController._();
    return _this!;
  }

  static MyMVCController? _this;

  MyMVCController._();

  int get counter => MyMVCModel().counter;

  void incrementCounter() {
    MyMVCModel.incrementCounter();
  }

  void decrementCounter() {
    MyMVCModel.decrementCounter();
  }
}
