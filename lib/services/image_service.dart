import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<String> saveImagePermanently(String imagePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = imagePath.split('/').last;

    final image = File(imagePath);

    final newImage = await image.copy('${dir.path}/$name');

    return newImage.path;
  }
}