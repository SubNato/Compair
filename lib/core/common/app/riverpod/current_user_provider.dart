
import 'package:compair_hub/core/common/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true) //Capital R in riverpod means that you are giving it something to do.
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  void setUser(User? user) {
    if(state != user ) state = user;
  }
}