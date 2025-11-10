import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class SearchAllProducts
    extends UsecaseWithParams<List<Product>, SearchAllProductsParams> {
  const SearchAllProducts(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(SearchAllProductsParams params) =>
      _repo.searchAllProducts(
        query: params.query,
        page: params.page,
        type: params.type,
      );
}

class SearchAllProductsParams extends Equatable {
  const SearchAllProductsParams({
    required this.query,
    required this.page,
    this.type,
  });

  final String query;
  final int page;
  final String? type;

  @override
  List<dynamic> get props => [
    query,
    page,
    type,
  ];
}
