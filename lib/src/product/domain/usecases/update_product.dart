import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateProduct {
  const UpdateProduct(this._repo);

  final ProductRepo _repo;

  ResultFuture<Product> call(UpdateProductParams params) =>
    _repo.updateProduct(
      productId: params.productId,
      updateData: params.updateData,
    );

  }

class UpdateProductParams extends Equatable {
  const UpdateProductParams({
    required this.productId,
    required this.updateData,
  });

  final String productId;
  final Map<String, dynamic> updateData;

  @override
  List<Object?> get props => [productId, updateData];
}