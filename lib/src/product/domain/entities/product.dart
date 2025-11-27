import 'dart:ui';

import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/entities/product_user.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.brand,
    required this.model,
    required this.rating,
    required this.colours,
    required this.image,
    required this.images,
    required this.reviewIds,
    required this.numberOfReviews,
    required this.sizes,
    required this.category,
    required this.owner,
    required this.countInStock,
    this.genderAgeCategory,
    this.type,
  });

  const Product.empty()
      : id = "Test String",
        name = "Test String",
        description = "Test String",
        price = 1,
        brand = "Test String",
        model = "Test String",
        rating = 1,
        colours = const [],
        image = "Test String",
        images = const [],
        reviewIds = const [],
        numberOfReviews = 1,
        sizes = const [],
        category = const ProductCategory.empty(),
        owner = const ProductUser.empty(),
        countInStock = 1,
        genderAgeCategory = "Test String",
        type = "Test String";

  final String id;
  final String name;
  final String description;
  final double price;
  final String brand;
  final String model;
  final double rating;
  final List<Color> colours;
  final String image;
  final List<String> images;
  final List<String> reviewIds;
  final int numberOfReviews;
  final List<String> sizes;
  final ProductCategory category;
  final ProductUser owner;
  final int countInStock;
  final String? genderAgeCategory;
  final String? type;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    brand,
    model,
    rating,
    image,
    numberOfReviews,
    category,
    owner,
    countInStock,
    genderAgeCategory,
    type,
  ];
}
