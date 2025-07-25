import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/cart/domain/entities/cart_product.dart';
import 'package:compair_hub/src/cart/domain/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

class AddToCart extends UsecaseWithParams<void, AddToCartParams> {
  const AddToCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(AddToCartParams params) => _repo.addToCart(
        userId: params.userId,
        cartProduct: params.cartProduct,
      );
}

class AddToCartParams extends Equatable {
  const AddToCartParams({
    required this.userId,
    required this.cartProduct,
  });

  final String userId;
  final CartProduct cartProduct;

  @override
  List<dynamic> get props => [
        userId,
        cartProduct,
      ];
}
