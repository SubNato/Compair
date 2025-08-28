import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/errors/failures.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/upload/product/data/datasources/upload_remote_datasource.dart';
import 'package:compair_hub/src/upload/product/domain/repositories/upload_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class UploadRepositoryImplementation implements UploadRepository {
  const UploadRepositoryImplementation(this._remoteDataSource);

  final UploadRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> upload({
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
    try {
      await _remoteDataSource.upload(
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
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
