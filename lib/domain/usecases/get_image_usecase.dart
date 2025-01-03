import 'dart:typed_data';

import 'package:solid_compare_img/data/repositories/image_repository.dart';

class GetImageUseCase {
  final ImageRepository imageRepository;

  GetImageUseCase({required this.imageRepository});

  Future<Uint8List> fetch(String imageUrl) async {
    return await imageRepository.fetchImage(imageUrl);
  }
}
