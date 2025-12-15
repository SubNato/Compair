import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';

class DeleteProduct {
  const DeleteProduct(this._repo);

  final ProductRepo _repo;

  ResultFuture<void> call(String productId) =>
      _repo.deleteProduct(productId: productId);
}