import 'dart:convert';
import 'dart:ui';

import 'package:compair_hub/core/common/app/cache_helper.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/error_response.dart';
import 'package:compair_hub/core/utils/network_utils.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/data/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract interface class CategoryUploadRemoteDataSource {
  const CategoryUploadRemoteDataSource();

  Future<void> upload({
    required String name,
    required http.MultipartFile image,
    required String type,
    String? color,
  });

  Future<List<ProductCategoryModel>> searchCategories({
    required String query,
    String? type,
  });
}

const CATEGORY_ENDPOINT = '/categories';
const CATEGORY_SEARCH_ENDPOINT = '$CATEGORY_ENDPOINT/search';

class CategoryUploadRemoteDataSourceImplementation
    implements CategoryUploadRemoteDataSource {
  const CategoryUploadRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> upload({
    required String name,
    required http.MultipartFile image,
    required String type,
    String? color,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.adminUrl}$CATEGORY_ENDPOINT');

      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(Cache.instance.sessionToken!.toAuthHeaders);

      request.fields['name'] = name;
      request.fields['type'] = type;
      request.files.add(image);

      if (color != null) {
        request.fields['color'] = color;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payLoad = jsonDecode(response.body) as DataMap;
        debugPrint(response.body);
        debugPrintStack();
        final errorResponse = ErrorResponse.fromMap(payLoad);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(label: e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's Not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ProductCategoryModel>> searchCategories({
    required String query,
    String? type,
  }) async {
    try {
      const endpoint = '${NetworkConstants.apiUrl}$CATEGORY_SEARCH_ENDPOINT';

      final queryParams = {
        'q': query,
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
          .map((category) => ProductCategoryModel.fromMap(category))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
    throw const ServerException(
      message: "Error Occured: It's not your fault, it's ours",
      statusCode: 500,
    );
  }
}
