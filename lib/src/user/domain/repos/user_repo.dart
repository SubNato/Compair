import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/utils/typedefs.dart';

abstract interface class UserRepo {
  const UserRepo();

  ResultFuture<User> getUser(String userId); //Ensure that you have matching usecases for each of these.

  ResultFuture<User> updateUser({
   required String userId,
   required DataMap updateData,
  });

  ResultFuture<String> getUserPaymentProfile(String userId);
}