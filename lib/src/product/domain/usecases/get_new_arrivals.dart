import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class GetNewArrivals
    extends UsecaseWithParams<List<Product>, GetNewArrivalsParams> {
  const GetNewArrivals(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetNewArrivalsParams params) =>
      _repo.getNewArrivals(
        page: params.page,
        categoryId: params.categoryId,
      );
}

class GetNewArrivalsParams extends Equatable {
  const GetNewArrivalsParams({required this.page, this.categoryId});

  final int page;
  final String? categoryId;

  @override
  List<Object?> get props => [page, categoryId];
}
