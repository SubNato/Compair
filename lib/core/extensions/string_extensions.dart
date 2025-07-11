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

  String get initials {
    if (isEmpty) return '';

    final words = trim().split(' ');

    String initials = '';

    for (int i = 0; i < words.length && i < 2; i++) {
      initials += words[i][0];
    }

    return initials.toUpperCase();
  }

  Color get colour => Color(int.parse(replaceFirst('#', 'ff'), radix: 16));

  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)}...';
    }
  }
}
