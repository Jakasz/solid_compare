import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ComparisonProvider extends ChangeNotifier {
  Uint8List? _image1bmp;
  Uint8List? _image2bmp;
  Uint8List? get imageData1 => _image1bmp;
  Uint8List? get imageData2 => _image2bmp;
  String comparisonResult = '';

  setFristImg(Uint8List data) {
    _image1bmp = data;
    notifyListeners();
  }

  setSecondImg(Uint8List data) {
    _image2bmp = data;
    notifyListeners();
  }

  void compareObjects() async {
    final img.Image? image1 = img.decodeImage(imageData1!);
    final img.Image? image2 = img.decodeImage(imageData2!);
    if (image1 == null || image2 == null) {
      comparisonResult = "ПОмилка опрацьовування зображення";
      notifyListeners();
      return;
    }

    if (image1.width != image2.width || image1.height != image2.height) {
      comparisonResult = "Розміри зображень не збігаються";
      notifyListeners();
      return;
    }

    double tolerance = 0.1;
    Uint8List pixelsImage1 = Uint8List.fromList(image1.getBytes());
    Uint8List pixelsImage2 = Uint8List.fromList(image2.getBytes());

    int diffPixels = 0;
    tolerance = tolerance.clamp(0.0, 1.0);
    int delta = (tolerance * 256).toInt();
    int totalPixels = image1.width * image1.height;

    for (int i = 0; i < totalPixels; i++) {
      int index = i * 4;
      int r1 = pixelsImage1[index];
      int g1 = pixelsImage1[index + 1];
      int b1 = pixelsImage1[index + 2];
      int a1 = pixelsImage1[index + 3];

      int r2 = pixelsImage2[index];
      int g2 = pixelsImage2[index + 1];
      int b2 = pixelsImage2[index + 2];
      int a2 = pixelsImage2[index + 3];

      if (!_usingRange(delta, r1, r2) ||
          !_usingRange(delta, g1, g2) ||
          !_usingRange(delta, b1, b2) ||
          !_usingRange(delta, a1, a2)) {
        diffPixels++;
      }
    }
    if (diffPixels > 0) {
      final diffPercent = (diffPixels / totalPixels) * 100;
      final double roundedValue = (diffPercent * 1000).round() / 1000;
      comparisonResult = "Зоображення відрізняються на $roundedValue%";
    } else {
      comparisonResult = "Зоображення однакові";
    }

    notifyListeners();
  }

  bool _usingRange(int delta, int value, int target) {
    return (target - delta <= value && value <= target + delta);
  }
}
