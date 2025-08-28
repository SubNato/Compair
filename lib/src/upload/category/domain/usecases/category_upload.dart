import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/upload/category/domain/repositories/category_upload_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class CategoryUpload extends UsecaseWithParams<void, CategoryUploadParams> {
  const CategoryUpload(this._repo);

  final CategoryUploadRepository _repo;

  @override
  ResultFuture<void> call(CategoryUploadParams params) =>
      _repo.categoryUpload(
        name: params.name,
        image: params.image,
        type: params.type,
        color: params.color,
      );
}

class CategoryUploadParams extends Equatable {
  const CategoryUploadParams({
    required this.name,
    required this.image,
    required this.type,
    this.color,
});

  final String name;
  final http.MultipartFile image;
  final String type;
  final String? color;

  @override
  List<dynamic> get props => [
    name,
    image,
    type,
    color,
  ];
}