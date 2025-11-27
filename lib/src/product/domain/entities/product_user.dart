
import 'package:equatable/equatable.dart';

class ProductUser extends Equatable {
  const ProductUser({
    required this.id,
  });

  //To test it
  const ProductUser.empty()
      : id = "Test String";

  final String id;

  @override
  List<Object?> get props => [id];
}
