import 'package:flutter/material.dart';

class AllProvider extends ChangeNotifier{

  String _lockedStatus = "ENTER USER PIN TO LOCK!";

  int _passStatus = 0;
  int _pageIndex = 1;
  int _bottomBarIndex = 1;
  int _lockStatusVisibility = 0;

  bool _isLocked = false;

  int get passStatus => _passStatus;
  int get pageIndex => _pageIndex;
  int get bottomBarIndex => _bottomBarIndex;
  int get lockStatus => _lockStatusVisibility;
  bool get isLocked => _isLocked;
  String get lockedStatus => _lockedStatus;

  void changePassStatus(int status){
    _passStatus = status;
    notifyListeners();
  }
  void changeLockStatus(int i){
    _lockStatusVisibility = i;
    changeIsLocked(true);
    notifyListeners();
  }
  void changePageIndex(int i){
    _pageIndex = i;
    notifyListeners();
  }
  void changeBarIndex(int i){
    _bottomBarIndex = i;
    notifyListeners();
  }
  void changeIsLocked(bool j){
    _isLocked = j;
  }
  void changeLockedText(String k){
    _lockedStatus = k;
    notifyListeners();
  }


}