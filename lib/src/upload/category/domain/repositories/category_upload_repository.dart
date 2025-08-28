import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:http/http.dart' as http;

abstract interface class CategoryUploadRepository {
  const CategoryUploadRepository();

  ResultFuture<void> categoryUpload({
    required String name,
    required http.MultipartFile image,
    required String type,
    String? color,
  });
}