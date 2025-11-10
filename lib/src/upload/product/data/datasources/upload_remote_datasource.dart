import 'dart:convert';

import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/error_response.dart';
import 'package:compair_hub/core/utils/network_utils.dart';
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
    required http.MultipartFile image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<http.MultipartFile>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
    String? type,
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
    required http.MultipartFile image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<http.MultipartFile>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
    String? type,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.adminUrl}$ADD_PRODUCT_ENDPOINT');

      //In order to send images or multiple images to the backend,
      //You need to use an http. MultipartRequest.
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(Cache.instance.sessionToken!.toAuthHeaders);

      //Then add the body items as fields
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['brand'] = brand;
      request.fields['category'] = category;
      request.fields['countInStock'] = countInStock.toString();

      if(type != null) request.fields['type'] = type;

      if(model != null) request.fields['model'] = model;
      if (genderAgeCategory != null) {
        request.fields['genderAgeCategory'] = genderAgeCategory;
      }
      if(colors != null) {
        for(int i = 0; i < colors.length; i++) {
          request.fields['colors[$i]'] = colors[i];
        }
      }

      if (sizes != null) {
        for (int i = 0; i < sizes.length; i++) {
          request.fields['sizes[$i]'] = sizes[i];
        }
      }

      //For one image
        request.files.add(image);

      //For multiple images
      if(images != null && images.isNotEmpty) {
        request.files.addAll(images);
      }

      //Then send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      // final response = await _client.post(
      //   uri,
      //   headers: Cache.instance.sessionToken!.toAuthHeaders,
      //   body: jsonEncode({
      //     'name': name,
      //     'description': description,
      //     'price': price,
      //     'brand': brand,
      //     'model': model,
      //     'colors': colors,
      //     'image': image,
      //     'images': images,
      //     'sizes': sizes,
      //     'category': category,
      //     'countInStock': countInStock,
      //     'genderAgeCategory': genderAgeCategory,
      //   }),
      // );
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        debugPrint(response.body);
        debugPrintStack();
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

