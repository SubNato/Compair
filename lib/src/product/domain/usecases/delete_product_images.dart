import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/repos/product_repo.dart';
import 'package:equatable/equatable.dart';

class DeleteProductImages {
  const DeleteProductImages(this._repo);

  final ProductRepo _repo;

  ResultFuture<List<String>> call(DeleteProductImagesParams params) =>
      _repo.deleteProductImages(
        productId: params.productId,
        imageUrls: params.imageUrls,
      );
}

class DeleteProductImagesParams extends Equatable {
  const DeleteProductImagesParams({
    required this.productId,
    required this.imageUrls,
  });

  final String productId;
  final List<String> imageUrls;

  @override
  List<Object?> get props => [productId, imageUrls];
}