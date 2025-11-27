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
  , type: params.type, owner: params.owner);
}

class GetProductsParams extends Equatable {
  const GetProductsParams({
    required this.page,
    this.type,
    this.owner,
});

  final int page;
  final String? type;
  final String? owner;

  @override
  List<dynamic> get props => [page, type, owner];
}
