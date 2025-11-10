import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetCategories
    extends UsecaseWithParams<List<ProductCategory>, GetCategoriesParams> {
  const GetCategories(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<ProductCategory>> call(GetCategoriesParams params) =>
      _repo.getCategories(type: params.type);
}

class GetCategoriesParams extends Equatable {
  const GetCategoriesParams({
    this.type,
  });

  final String? type;

  @override
  List<dynamic> get props => [type];
}

/*Works
*
* class GetCategories extends UsecaseWithoutParams<List<ProductCategory>> {
  const GetCategories(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<ProductCategory>> call() => _repo.getCategories();
}

*
* */
