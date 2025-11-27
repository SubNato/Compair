// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/error_response.dart';
import 'package:compair_hub/core/utils/network_utils.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/data/models/category_model.dart';
import 'package:compair_hub/src/product/data/models/product_model.dart';
import 'package:compair_hub/src/product/data/models/review_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class ProductRemoteDataSrc {
  const ProductRemoteDataSrc();

  Future<List<ProductModel>> getProducts(int page, {String? type, String? owner});

  Future<ProductModel> getProduct(String productId);

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
    String? type,
  });

  Future<List<ProductModel>> getNewArrivals({
    required int page,
    String? categoryId,
    String? type,
  });

  Future<List<ProductModel>> getPopular({
    required int page,
    String? categoryId,
    String? type,
  });

  Future<List<ProductModel>> searchAllProducts({
    required String query,
    required int page,
    String? type,
  });

  Future<List<ProductModel>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
    String? type,
  });

  Future<List<ProductModel>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
    String? type,
  });

  Future<List<ProductCategoryModel>> getCategories({String? type});

  Future<ProductCategoryModel> getCategory(String categoryId);

  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    required int page,
  });
}

const GET_PRODUCTS_ENDPOINT = '/products';
const SEARCH_PRODUCTS_ENDPOINT = '$GET_PRODUCTS_ENDPOINT/search';
const GET_CATEGORIES_ENDPOINT = '/categories';
const GET_PRODUCT_REVIEWS_ENDPOINT = '/reviews';

class ProductRemoteDataSrcImpl implements ProductRemoteDataSrc {
  const ProductRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<List<ProductCategoryModel>> getCategories({String? type}) async {
    try {/*
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_CATEGORIES_ENDPOINT',
      );*/

      const endpoint = '${NetworkConstants.apiUrl}$GET_CATEGORIES_ENDPOINT';

      final queryParams = {
        if (type != null) 'type': type, //Adding the type to the query if provided
      };
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);


      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body);

      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((category) => ProductCategoryModel.fromMap(category))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<ProductCategoryModel> getCategory(String categoryId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_CATEGORIES_ENDPOINT/$categoryId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return ProductCategoryModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> getNewArrivals({
    required int page,
    String? categoryId,
    String? type,
  }) async {
    try { print("The type is: $type --------------------------------------");
      const endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {
        'criteria': 'newArrivals',
        if (categoryId != null) 'category': categoryId,
        'page': '$page',
        if (type != null) 'type': type,
      };

      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> getPopular({
    required int page,
    String? categoryId,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {
        'criteria': 'popular',
        if (categoryId != null) 'category': categoryId,
        'page': '$page',
        if (type != null ) 'type': type,
      };

      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<ProductModel> getProduct(String productId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_PRODUCTS_ENDPOINT/$productId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return ProductModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    required int page,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT'
          '/$productId$GET_PRODUCT_REVIEWS_ENDPOINT';

      final queryParams = {'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((review) => ReviewModel.fromMap(review))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> getProducts(int page, {String? type, String? owner}) async {
    try {print("The type is: $type --------------------------------------");
      const endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {
        'page': '$page',
        if (type != null) 'type': type, //Adding the type to the query if provided
        if (owner != null) 'owner': owner, //Adding the type to the query if provided
      };
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {'category': categoryId, 'page': '$page', if (type != null) 'type': type};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_PRODUCTS_ENDPOINT'
            '/$productId$GET_PRODUCT_REVIEWS_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({
          'user': userId,
          'comment': comment,
          'rating': rating,
        }),
      );

      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> searchAllProducts({
    required String query,
    required int page,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {'q': query, 'page': '$page', if (type != null) 'type': type};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {'q': query, 'category': categoryId, 'page': '$page', if (type != null) 'type': type};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductModel>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {
        'q': query,
        'category': categoryId,
        'genderAgeCategory': genderAgeCategory,
        'page': '$page',
        if (type != null) 'type': type,
      };
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map((product) => ProductModel.fromMap(product))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }
}
