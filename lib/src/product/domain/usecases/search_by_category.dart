import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class SearchByCategory
    extends UsecaseWithParams<List<Product>, SearchByCategoryParams> {
  const SearchByCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(SearchByCategoryParams params) =>
      _repo.searchByCategory(
        query: params.query,
        categoryId: params.categoryId,
        page: params.page,
        type: params.type,
        parish: params.parish,
      );
}

class SearchByCategoryParams extends Equatable {
  const SearchByCategoryParams({
    required this.query,
    required this.categoryId,
    required this.page,
    this.type,
    this.parish,
  });

  final String query;
  final String categoryId;
  final int page;
  final String? type;
  final String? parish;


  @override
  List<dynamic> get props => [
    query,
    categoryId,
    page,
    type,
    parish,
  ];
}
