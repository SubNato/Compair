import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    this.name,
    this.color,
    this.image,
    this.type,
  });

  const ProductCategory.empty() : this(id: 'Test String');

  const ProductCategory.all() : this(id: '', name: 'All');

  final String id;
  final String? name;
  final String? color;
  final String? image;
  final String? type;

  @override
  List<Object?> get props => [id, name, color, image, type];
}
