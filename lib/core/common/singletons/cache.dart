import 'package:flutter/material.dart';

class Cache {
  Cache._internal(); //Could be named anything, but this keeps it inside here.

  static final Cache instance = Cache._internal();

  String? _sessionToken;
  String? _userId;
  final themeModeNotifier = ValueNotifier(ThemeMode.system); //To listen for the change in app theme (dark mode, light mode).

  String? get sessionToken => _sessionToken;
  String? get userId => _userId;

  //Methods are better when setting tokens!
  void setSessionToken(String? newToken) {
    if(_sessionToken != newToken) _sessionToken = newToken;
  }

  void setUserId(String? newUserId) {
    if(_userId != newUserId) _userId = newUserId;
  }

  void setThemeMode(ThemeMode themeMode) {
    if(themeModeNotifier.value != themeMode) {
      themeModeNotifier.value = themeMode;
    }
  }

  void resetSession() {
    setSessionToken(null);
    setUserId(null); //You don't have to reset the user's theme, if it's their preferred, then just leave it.
  }
}