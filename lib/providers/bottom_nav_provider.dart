import 'package:flutter/foundation.dart';
import 'package:taskist_app/model/bottom_nav_model.dart';

class BottomNavProvider extends ChangeNotifier {
  BottomNavModel _navModel = const BottomNavModel(0);

  int get currentIndex => _navModel.currentIndex;

  void setIndex(int newIndex) {
    _navModel = BottomNavModel(newIndex);
    notifyListeners();
  }
}
