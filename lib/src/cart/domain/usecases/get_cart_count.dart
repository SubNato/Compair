import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/cart/domain/repos/cart_repo.dart';

class GetCartCount extends UsecaseWithParams<int, String> {
  const GetCartCount(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<int> call(String params) => _repo.getCartCount(params);
}
