import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/user/domain/repos/user_repo.dart';

class GetUser extends UsecaseWithParams<User, String> {
  const GetUser(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call(String params) => _repo.getUser(params);
}