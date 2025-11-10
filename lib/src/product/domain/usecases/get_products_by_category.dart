import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetProductsByCategory
    extends UsecaseWithParams<List<Product>, GetProductsByCategoryParams> {
  const GetProductsByCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetProductsByCategoryParams params) =>
      _repo.getProductsByCategory(
        categoryId: params.categoryId,
        page: params.page,
        type: params.type,
      );
}

class GetProductsByCategoryParams extends Equatable {
  const GetProductsByCategoryParams({
    required this.categoryId,
    required this.page,
    this.type,
  });

  final String categoryId;
  final int page;
  final String? type;

  @override
  List<Object?> get props => [categoryId, page, type];
}
