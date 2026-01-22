import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/domain/entities/review.dart';
import 'package:compair_hub/src/product/domain/usecases/delete_product.dart';
import 'package:compair_hub/src/product/domain/usecases/delete_product_images.dart';
import 'package:compair_hub/src/product/domain/usecases/get_categories.dart';
import 'package:compair_hub/src/product/domain/usecases/get_category.dart';
import 'package:compair_hub/src/product/domain/usecases/get_new_arrivals.dart';
import 'package:compair_hub/src/product/domain/usecases/get_popular.dart';
import 'package:compair_hub/src/product/domain/usecases/get_product.dart';
import 'package:compair_hub/src/product/domain/usecases/get_product_reviews.dart';
import 'package:compair_hub/src/product/domain/usecases/get_products.dart';
import 'package:compair_hub/src/product/domain/usecases/get_products_by_category.dart';
import 'package:compair_hub/src/product/domain/usecases/leave_review.dart';
import 'package:compair_hub/src/product/domain/usecases/search_all_products.dart';
import 'package:compair_hub/src/product/domain/usecases/search_by_category.dart';
import 'package:compair_hub/src/product/domain/usecases/search_by_category_and_gender_age_category.dart';
import 'package:compair_hub/src/product/domain/usecases/search_categories.dart';
import 'package:compair_hub/src/product/domain/usecases/update_product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_adapter.g.dart';

part 'product_state.dart';

@riverpod
class ProductAdapter extends _$ProductAdapter {
  @override
  ProductState build([GlobalKey? familyKey]) {
    _getCategories = sl<GetCategories>();
    _getCategory = sl<GetCategory>();
    _getNewArrivals = sl<GetNewArrivals>();
    _getPopular = sl<GetPopular>();
    _getProduct = sl<GetProduct>();
    _getProductReviews = sl<GetProductReviews>();
    _getProducts = sl<GetProducts>();
    _getProductsByCategory = sl<GetProductsByCategory>();
    _leaveReview = sl<LeaveReview>();
    _searchAllProducts = sl<SearchAllProducts>();
    _searchByCategory = sl<SearchByCategory>();
    _updateProduct = sl<UpdateProduct>();
    _deleteProduct = sl<DeleteProduct>();
    _deleteProductImages = sl<DeleteProductImages>();
    _searchByCategoryAndGenderAgeCategory =
        sl<SearchByCategoryAndGenderAgeCategory>();
    _searchCategories = sl<SearchCategories>();
    return const ProductInitial();
  }

  late GetCategories _getCategories;
  late GetCategory _getCategory;
  late GetNewArrivals _getNewArrivals;
  late GetPopular _getPopular;
  late GetProduct _getProduct;
  late GetProductReviews _getProductReviews;
  late GetProducts _getProducts;
  late GetProductsByCategory _getProductsByCategory;
  late LeaveReview _leaveReview;
  late SearchAllProducts _searchAllProducts;
  late SearchByCategory _searchByCategory;
  late UpdateProduct _updateProduct;
  late DeleteProduct _deleteProduct;
  late DeleteProductImages _deleteProductImages;
  late SearchByCategoryAndGenderAgeCategory
  _searchByCategoryAndGenderAgeCategory;
  late SearchCategories _searchCategories;

  Future<void> getCategories({String? type}) async {
    state = const FetchingCategories();
    final result = await _getCategories(GetCategoriesParams(type: type));

    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (categories) => state = CategoriesFetched(categories),
    );
  }

  Future<void> getCategory(String categoryId) async {
    state = const FetchingCategory();
    final result = await _getCategory(categoryId);
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (category) => state = CategoryFetched(category),
    );
  }

  Future<void> getNewArrivals(
      {required int page, String? categoryId, String? type}) async {
    state = const FetchingProducts();
    final result = await _getNewArrivals(GetNewArrivalsParams(
      page: page,
      categoryId: categoryId,
      type: type,
    ));
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getPopular(
      {required int page, String? categoryId, String? type}) async {
    state = const FetchingProducts();
    final result = await _getPopular(GetPopularParams(
      page: page,
      categoryId: categoryId,
      type: type,
    ));
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getProduct(String productId) async {
    state = const FetchingProduct();
    final result = await _getProduct(productId);
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (product) => state = ProductFetched(product),
    );
  }

  Future<void> getProductReviews({
    required String productId,
    required int page,
  }) async {
    state = const FetchingReviews();
    final result = await _getProductReviews(
      GetProductReviewsParams(productId: productId, page: page),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (reviews) {
        state = ReviewsFetched(reviews);
      },
    );
  }

  Future<void> getProducts(int page,
      {String? type, String? owner, String? parish}) async {
    state = const FetchingProducts();
    final result = await _getProducts(GetProductsParams(
        page: page, type: type, owner: owner, parish: parish));
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> getProductsByCategory({
    required String categoryId,
    required int page,
    String? type,
    String? parish,
  }) async {
    state = const FetchingProducts();
    final result = await _getProductsByCategory(
      GetProductsByCategoryParams(
          categoryId: categoryId, page: page, type: type, parish: parish),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    state = const Reviewing();
    final result = await _leaveReview(
      LeaveReviewParams(
        productId: productId,
        userId: userId,
        comment: comment,
        rating: rating,
      ),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (_) => state = const ProductReviewed(),
    );
  }

  Future<void> searchAllProducts({
    required String query,
    required int page,
    String? type,
    String? parish,
  }) async {
    state = const Searching();
    final result = await _searchAllProducts(
      SearchAllProductsParams(
        query: query,
        page: page,
        type: type,
        parish: parish,
      ),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
    String? type,
    String? parish,
  }) async {
    state = const Searching();
    final result = await _searchByCategory(
      SearchByCategoryParams(
          query: query,
          categoryId: categoryId,
          page: page,
          type: type,
          parish: parish),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
    String? type,
  }) async {
    state = const Searching();
    final result = await _searchByCategoryAndGenderAgeCategory(
      SearchByCategoryAndGenderAgeCategoryParams(
        query: query,
        categoryId: categoryId,
        genderAgeCategory: genderAgeCategory,
        page: page,
        type: type,
      ),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (products) => state = ProductsFetched(products),
    );
  }

  Future<void> searchCategories({
    required String query,
    String? type,
  }) async {
    state = const SearchingCategories();

    final result = await _searchCategories(
      SearchCategoriesParams(query: query, type: type),
    );

    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (categories) => state = CategoriesSearched(categories),
    );
  }

  Future<void> updateProduct({
    required String productId,
    required Map<String, dynamic> updateData,
  }) async {
    state = const UpdatingProduct();
    final result = await _updateProduct(
      UpdateProductParams(
        productId: productId,
        updateData: updateData,
      ),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (product) => state = ProductUpdated(product),
    );
  }

  Future<void> deleteProduct(String productId) async {
    state = const DeletingProduct();
    final result = await _deleteProduct(productId);
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (_) => state = const ProductDeleted(),
    );
  }

  Future<void> deleteProductImages({
    required String productId,
    required List<String> imageUrls,
  }) async {
    state = const DeletingProductImages();
    final result = await _deleteProductImages(
      DeleteProductImagesParams(
        productId: productId,
        imageUrls: imageUrls,
      ),
    );
    result.fold(
          (failure) => state = ProductError(failure.errorMessage),
          (remainingImages) => state = ProductImagesDeleted(remainingImages),
    );
  }
}
