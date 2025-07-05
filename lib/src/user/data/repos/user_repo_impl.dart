import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/errors/exceptions.dart';
import 'package:compair_hub/core/errors/failures.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/user/data/datasources/user_remote_data_src.dart';
import 'package:compair_hub/src/user/domain/repos/user_repo.dart';
import 'package:dartz/dartz.dart';

class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSrc);

  final UserRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<User> getUser(String userId) async {
    //Same for all datasources. Keep in mind, they have to be similar to their implementation or what they return from the server! So Pay attention to that.
    try {
      final result = await _remoteDataSrc.getUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final result = await _remoteDataSrc.getUserPaymentProfile(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<User> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    try {
      final result = await _remoteDataSrc.updateUser(
        userId: userId,
        updateData: updateData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
