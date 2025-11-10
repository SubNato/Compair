import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetPopular extends UsecaseWithParams<List<Product>, GetPopularParams> {
  const GetPopular(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetPopularParams params) => _repo.getPopular(
    page: params.page,
    categoryId: params.categoryId,
    type: params.type,
  );
}

class GetPopularParams extends Equatable {
  const GetPopularParams({
    required this.page,
    this.categoryId,
    this.type,
  });

  final int page;
  final String? categoryId;
  final String? type;

  @override
  List<Object?> get props => [page, categoryId, type];
}
