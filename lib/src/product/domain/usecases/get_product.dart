import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';

class GetProduct extends UsecaseWithParams<Product, String> {
  const GetProduct(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<Product> call(String params) => _repo.getProduct(params);
}
