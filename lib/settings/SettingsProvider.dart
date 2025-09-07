import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider with ChangeNotifier {
  bool _autoOpenUrls = false;
  bool _autoSaveQRCodes = false;

  bool get autoOpenUrls => _autoOpenUrls;
  bool get autoSaveQRCodes => _autoSaveQRCodes;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    final box = Hive.box('settings');
    _autoOpenUrls = box.get('autoOpenUrls', defaultValue: false);
    _autoSaveQRCodes = box.get('autoSaveQRCodes', defaultValue: false);
  }

  void toggleAutoOpenUrls(bool value) {
    _autoOpenUrls = value;
    Hive.box('settings').put('autoOpenUrls', value);
    notifyListeners();
  }

  void toggleAutoSaveQRCodes(bool value) {
    _autoSaveQRCodes = value;
    Hive.box('settings').put('autoSaveQRCodes', value);
    notifyListeners();
  }
}
