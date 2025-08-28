import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/errors/failures.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/upload/category/data/datasources/category_upload_remote_datasource.dart';
import 'package:compair_hub/src/upload/category/domain/repositories/category_upload_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CategoryUploadRepositoryImplementation
    implements CategoryUploadRepository {
  const CategoryUploadRepositoryImplementation(this._remoteDataSource);

  final CategoryUploadRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> categoryUpload({
    required String name,
    required http.MultipartFile image,
    required String type,
    String? color,
  }) async {
    try {
      await _remoteDataSource.upload(
        name: name,
        image: image,
        type: type,
        color: color,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
