import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/upload/domain/repositories/upload_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class Upload extends UsecaseWithParams<void, UploadParams> {
  const Upload(this._repo);

  final UploadRepository _repo;

  @override
  ResultFuture<void> call(UploadParams params) =>
      _repo.upload(
          name: params.name,
          description: params.description,
          price: params.price,
          brand: params.brand,
          model: params.model,
          colors: params.colors,
          image: params.image,
          images: params.images,
          sizes: params.sizes,
          category: params.category,
          countInStock: params.countInStock,
          genderAgeCategory: params.genderAgeCategory
      );
}

class UploadParams extends Equatable {
  const UploadParams({
    required this.name,
    required this.description,
    required this.price,
    required this.brand,
    required this.image,
    required this.category,
    required this.countInStock,
    this.model,
    this.colors,
    this.images,
    this.sizes,
    this.genderAgeCategory,
});

  final String name;
  final String description;
  final double price;
  final String brand;
  final http.MultipartFile image;
  final String category;
  final int countInStock;
  final List<String>? colors;
  final List<http.MultipartFile>? images;
  final List<String>? sizes;
  final String? model;
  final String? genderAgeCategory;

  @override
  List<dynamic> get props => [
    name,
    description,
    price,
    brand,
    model,
    colors,
    image,
    images,
    sizes,
    category,
    countInStock,
    genderAgeCategory,
  ];
}