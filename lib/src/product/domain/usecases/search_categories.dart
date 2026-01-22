import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/data/models/category_model.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class SearchCategories extends UsecaseWithParams<List<ProductCategory>, SearchCategoriesParams> {
  const SearchCategories(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<ProductCategory>> call(SearchCategoriesParams params) =>
      _repo.searchCategories(
        query: params.query,
        type: params.type,
      );
}

class SearchCategoriesParams extends Equatable {
  const SearchCategoriesParams({
    required this.query,
    this.type,
});

  final String query;
  final String? type;

  @override
  List<dynamic> get props => [
    query,
    type,
  ];
}