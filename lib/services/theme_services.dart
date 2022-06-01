import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkmode';

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  bool _reloadThemeFromBox() => _box.read<bool>(_key) ?? false;
  ThemeMode get theme =>
      _reloadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  switchTheme() {
    Get.changeThemeMode(
        _reloadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_reloadThemeFromBox());
  }
}
