import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/user/domain/repos/user_repo.dart';

class GetUserPaymentProfile extends UsecaseWithParams<String, String> {
  const GetUserPaymentProfile(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<String> call(String params) =>
      _repo.getUserPaymentProfile(params);
}
