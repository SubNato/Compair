import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetProducts extends UsecaseWithParams<List<Product>, GetProductsParams> {
  const GetProducts(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetProductsParams params) => _repo.getProducts(params.page
  , type: params.type);
}

class GetProductsParams extends Equatable {
  const GetProductsParams({
    required this.page,
    this.type,
});

  final int page;
  final String? type;

  @override
  List<dynamic> get props => [page, type];
}
