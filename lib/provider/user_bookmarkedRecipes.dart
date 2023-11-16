import 'package:flutter/material.dart';

class UserBookmarked with ChangeNotifier {
  List<Map> _bookmarkedRecipes = [];

  List<Map> get bookmarkedRecipes => _bookmarkedRecipes;

  void addUserBookmarked(Map recipe) {
    _bookmarkedRecipes.add(recipe);
    notifyListeners();
  }

  void removeUserBookmarked(Map recipe) {
    _bookmarkedRecipes.remove(recipe);
    notifyListeners();
  }

  void resetUserAllergies() {
    _bookmarkedRecipes =[];
    notifyListeners();
  }
}