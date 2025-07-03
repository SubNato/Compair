import 'package:flutter/material.dart';

extension StringExt on String {
  Map<String, String> get toAuthHeaders {
    return {
      'Authorization': 'Bearer $this',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  ThemeMode get toThemeMode {
    return switch (toLowerCase()) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String get obscureEmail {
    // here we split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // then I'll convert part of the username to ***, then leave in only the
    // first and last characters
    username = '${username[0]}****${username[username.length - 1]}';

    return '$username@$domain';
  }
}
