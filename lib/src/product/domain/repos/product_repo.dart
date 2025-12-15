import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/entities/review.dart';

abstract interface class ProductRepo {
  ResultFuture<List<Product>> getProducts(
    int page, {
    String? type,
    String? owner,
    String? parish,
  });

  ResultFuture<Product> getProduct(String productId);

  ResultFuture<List<Product>> getProductsByCategory({
    required String categoryId,
    required int page,
    String? type,
    String? parish,
  });

  ResultFuture<List<Product>> getNewArrivals({
    required int page,
    String? categoryId,
    String? type,
  });

  ResultFuture<List<Product>> getPopular({
    required int page,
    String? categoryId,
    String? type,
  });

  ResultFuture<List<Product>> searchAllProducts({
    required String query,
    required int page,
    String? type,
    String? parish,
  });

  ResultFuture<List<Product>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
    String? type,
    String? parish,
  });

  ResultFuture<List<Product>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
    String? type,
  });

  ResultFuture<List<ProductCategory>> getCategories({String? type});

  ResultFuture<ProductCategory> getCategory(String categoryId);

  ResultFuture<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  ResultFuture<List<Review>> getProductReviews({
    required String productId,
    required int page,
  });

  ResultFuture<Product> updateProduct({
    required String productId,
    required Map<String, dynamic> updateData,
  });

  ResultFuture<void> deleteProduct({
    required String productId,
  });

  ResultFuture<List<String>> deleteProductImages({
    required String productId,
    required List<String> imageUrls,
  });
}
