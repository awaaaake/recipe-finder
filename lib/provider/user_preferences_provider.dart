import 'package:flutter/material.dart';

class UserPrefer with ChangeNotifier {
  List<String> _userLikes  = [];
  List<String> _userAllergies  = [];

  List<String> get userLikes => _userLikes;
  List<String> get userAllergies => _userAllergies;

  void addUserLikes(String ingredient) {
    _userLikes.add(ingredient);
    notifyListeners();
  }

  void removeUserLikes(String ingredient) {
    _userLikes.remove(ingredient);
    notifyListeners();
  }

  void resetUserLikes() {
    _userLikes =[];
    notifyListeners();
  }

  void addUserAllergies(String ingredient) {
    _userAllergies.add(ingredient);
    notifyListeners();
  }

  void removeUserAllergies(String ingredient) {
    _userAllergies.remove(ingredient);
    notifyListeners();
  }

  void resetUserAllergies() {
    _userAllergies =[];
    notifyListeners();
  }

}