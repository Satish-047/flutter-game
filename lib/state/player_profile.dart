import 'package:flutter/foundation.dart';

/// Single source of truth for points (and future profile fields) across tabs.
class PlayerProfile extends ChangeNotifier {
  PlayerProfile({int initialPoints = 1250}) : _points = initialPoints;

  int _points;
  int get points => _points;

  set points(int v) {
    if (v == _points) return;
    _points = v;
    notifyListeners();
  }

  void addPoints(int delta) {
    if (delta == 0) return;
    _points += delta;
    notifyListeners();
  }
}
