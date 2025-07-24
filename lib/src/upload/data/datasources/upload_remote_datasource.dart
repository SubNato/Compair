import 'dart:convert';

import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/error_response.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract interface class UploadRemoteDataSource {
  const UploadRemoteDataSource();

  Future<void> upload({
    required String name,
    required String description,
    required double price,
    required String brand,
    required String image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<String>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
  });
}

const ADD_PRODUCT_ENDPOINT = '/products';

class UploadRemoteDataSourceImplementation implements UploadRemoteDataSource {
  const UploadRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> upload({
    required String name,
    required String description,
    required double price,
    required String brand,
    required String image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<String>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$ADD_PRODUCT_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'brand': brand,
          'model': model,
          'colors': colors,
          'image': image,
          'images': images,
          'sizes': sizes,
          'category': category,
          'countInStock': countInStock,
          'genderAgeCategory': genderAgeCategory,
        }),
        headers: NetworkConstants.headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
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
        message: "Error Occured: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }
}

