import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/upload/category/domain/usecases/category_upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_upload_adapter.g.dart';
part 'category_upload_state.dart';

@riverpod
class CategoryUploadAdapter extends _$CategoryUploadAdapter {

  @override
  CategoryUploadState build([GlobalKey? familyKey]) {
    _upload = sl<CategoryUpload>();
    return const CategoryUploadInitial();
  }

  late CategoryUpload _upload;

  Future<void> categoryUpload({
   required String name,
   required http.MultipartFile image,
   required String type,
   String? color,
}) async {
    state = const CategoryUploadLoading();
    final result = await _upload(CategoryUploadParams(
        name: name,
        image: image,
        type: type
    ));
    result.fold(
        (failure) => state = CategoryUploadError(failure.errorMessage),
        (_) => state = const CategoryUploaded(),
    );
  }
}