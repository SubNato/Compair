import 'package:http_parser/http_parser.dart';

extension MimeTypeExtension on String {
  MediaType? get imageMimeType {
    final ext = split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
        return MediaType('image', 'jpg');
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'heic':
        return MediaType('image', 'heic');
      case 'heif':
        return MediaType('image', 'heif');
      default:
        return null;
    }
  }
}