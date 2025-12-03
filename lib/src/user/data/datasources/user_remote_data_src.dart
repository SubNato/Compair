// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:compair_hub/core/common/models/user_model.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/extensions/image_extension.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/error_response.dart';
import 'package:compair_hub/core/utils/network_utils.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class UserRemoteDataSrc {
  const UserRemoteDataSrc();
  Future<UserModel> getUser(String userId);

  Future<UserModel> updateUser({
    required String userId,
    required DataMap updateData,
  });

  Future<String> getUserPaymentProfile(String userId);
}

const USERS_ENDPOINT = '/users';

class UserRemoteDataSrcImpl implements UserRemoteDataSrc {
  const UserRemoteDataSrcImpl(this._client);

  final http.Client _client;

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return UserModel.fromMap(payload);
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
  Future<String> getUserPaymentProfile(String userId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId/paymentProfile',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return payload['url'] as String;
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
  Future<UserModel> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId',
      );

      // Check if we have a file to upload
      final hasProfilePicture = updateData.containsKey('profilePicture') &&
          updateData['profilePicture'] is File;
      final shouldRemoveProfilePicture = updateData.containsKey('profilePicture') &&
          updateData['profilePicture'] == 'REMOVE';

      http.Response response;

      if (hasProfilePicture || shouldRemoveProfilePicture) {
        // Use multipart request for file upload
        final request = http.MultipartRequest('PUT', uri);

        // Add authorization headers
        request.headers.addAll(Cache.instance.sessionToken!.toAuthHeaders);

        // Add text fields
        updateData.forEach((key, value) {
          if (key != 'profilePicture') {
            request.fields[key] = value.toString();
          }
        });

        // Handle profile picture
        if (shouldRemoveProfilePicture) {
          request.fields['removeProfilePicture'] = 'true';
        } else if (hasProfilePicture) {
          final profilePicture = updateData['profilePicture'] as File;
          final mimeType = profilePicture.path.imageMimeType;

          if (mimeType != null) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'profilePicture',
                profilePicture.path,
                contentType: mimeType,
              ),
            );
          } else {
            throw const ServerException(
              message: 'Unsupported image format',
              statusCode: 400,
            );
          }
        }

        // Send multipart request
        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // Use regular PUT request for text-only updates
        response = await _client.put(
          uri,
          body: jsonEncode(updateData),
          headers: Cache.instance.sessionToken!.toAuthHeaders,
        );
      }

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromMap(payload);
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

  //Works without the profile picture. Original file
  // @override
  // Future<UserModel> updateUser({
  //   required String userId,
  //   required DataMap updateData,
  // }) async {
  //   try {
  //     final uri = Uri.parse(
  //       '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId',
  //     );
  //
  //     final response = await _client.put(
  //       uri,
  //       body: jsonEncode(updateData),
  //       headers: Cache.instance.sessionToken!.toAuthHeaders,
  //     );
  //
  //     final payload = jsonDecode(response.body) as DataMap;
  //     await NetworkUtils.renewToken(response);
  //
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       final errorResponse = ErrorResponse.fromMap(payload);
  //       throw ServerException(
  //         message: errorResponse.errorMessage,
  //         statusCode: response.statusCode,
  //       );
  //     }
  //     return UserModel.fromMap(payload);
  //   } on ServerException {
  //     rethrow;
  //   } catch (e, s) {
  //     debugPrint(e.toString());
  //     debugPrintStack(stackTrace: s);
  //     throw const ServerException(
  //       message: "Error Occurred: It's not your fault, it's ours",
  //       statusCode: 500,
  //     );
  //   }
  // }
}
