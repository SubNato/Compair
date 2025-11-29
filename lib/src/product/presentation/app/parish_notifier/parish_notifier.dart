
import 'package:compair_hub/core/utils/enums/jamaican_parishes.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parish_notifier.g.dart';

@riverpod
class ParishNotifier extends _$ParishNotifier {
  @override
  JamaicanParishes? build([GlobalKey? familyKey]) {
   //If all is selected, you send null, because when null everything returns anyway
    return null;
  }

  void changeParish(JamaicanParishes? parish) {
    if(state != parish) state = parish;
  }

  void clearParish() {
    state = null;
  }
}