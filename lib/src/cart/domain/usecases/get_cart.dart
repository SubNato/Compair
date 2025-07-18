import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/cart/domain/entities/cart_product.dart';
import 'package:compair_hub/src/cart/domain/repos/cart_repo.dart';

class GetCart extends UsecaseWithParams<List<CartProduct>, String> {
  const GetCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<List<CartProduct>> call(String params) => _repo.getCart(params);
}
