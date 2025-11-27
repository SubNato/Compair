
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/product/domain/entities/product_user.dart';

class ProductUserModel extends ProductUser {
  const ProductUserModel({
    required super.id,
  });

  const ProductUserModel.empty()
      : this(
    id: "Test String",
  );

  ProductUser copyWith({
    String? id,
  }) {
    return ProductUserModel(
      id: id ?? this.id,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
    };
  }

  factory ProductUserModel.fromMap(Map<String, dynamic> map) {
    return ProductUserModel(
      id: map['id'] as String? ?? map['_id'] as String,
    );
  }
}
