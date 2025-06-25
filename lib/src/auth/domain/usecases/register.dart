import 'package:compair_hub/core/usecase/usecase.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class Register extends UsecaseWithParams<void, RegisterParams> {
  const Register(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(RegisterParams params) => _repo.register(
    name: params.name,
    password: params.password,
    parish: params.parish,
    email: params.email,
    phone: params.phone,
  );
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.password,
    required this.parish,
    required this.email,
    required this.phone,
  });

  final String name;
  final String password;
  final String parish;
  final String email;
  final String phone;

  @override
  List<dynamic> get props => [
    name,
    password,
    parish,
    email,
    phone,
  ];
}
