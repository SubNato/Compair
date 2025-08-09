import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/upload/domain/usecases/upload.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_adapter.g.dart';
part 'upload_state.dart';

@riverpod
class UploadAdapter extends _$UploadAdapter {
  //Using a template!

  @override
  UploadState build([GlobalKey? familyKey]) {
    _upload = sl<Upload>();
    return const UploadInitial();
  }

  late Upload _upload;

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
  }) async {
     state = const UploadLoading();
     final result = await _upload(UploadParams(
       name: name,
       description: description,
       price: price,
       brand: brand,
       model: model,
       colors: colors,
       image: image,
       images: images,
       sizes: sizes,
       category: category,
       countInStock: countInStock,
       genderAgeCategory: genderAgeCategory,
     ));
     result.fold(
      (failure) => state = UploadError(failure.errorMessage),
      (_) => state = const Uploaded(),
    );
  }
}