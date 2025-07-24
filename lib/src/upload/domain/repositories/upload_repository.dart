import 'package:compair_hub/core/utils/typedefs.dart';

abstract interface class UploadRepository {
  const UploadRepository();

  ResultFuture<void> upload({
    required String name,
    required String description,
    required double price,
    required String brand,
    required String image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<String>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
  });
}