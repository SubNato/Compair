import 'package:compair_hub/src/product/domain/entities/category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    super.name,
    super.color,
    super.image,
    super.type,
  });

  const ProductCategoryModel.empty() : super(id: 'Test String');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'image': image,
      'type': type
    };
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'] as String? ?? map['_id'] as String,
      name: map['name'] as String?,
      color: map['color'] as String?,
      image: map['image'] as String?,
      type: map['type'] as String?,
    );
  }

  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? color,
    String? image,
    String? type,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }
}
