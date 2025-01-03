import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'image_repository.dart'; // Імпортуємо інтерфейс

class ImageFetch implements ImageRepository {
  @override
  Future<Uint8List> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed');
    }
  }
}
