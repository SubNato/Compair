import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:http/http.dart' as http;

abstract interface class UploadRepository {
  const UploadRepository();

  ResultFuture<void> upload({
    required String name,
    required String description,
    required double price,
    required String brand,
    required http.MultipartFile image,
    required String category,
    required int countInStock,
    List<String>? colors,
    List<http.MultipartFile>? images,
    List<String>? sizes,
    String? model,
    String? genderAgeCategory,
    String? type,
  });
}