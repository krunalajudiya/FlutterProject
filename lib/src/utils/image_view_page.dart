import 'package:emgage_flutter/src/constants/ColorCode.dart';
import 'package:emgage_flutter/src/constants/image_path.dart';
import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final String imageUrl;
  final String imageName;

  const ImageViewPage(
      {super.key, required this.imageUrl, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(imageName),
        ),
        body: Center(
            child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                child: Image.network(
                    width: double.infinity, height: double.infinity,
                    loadingBuilder: (buildContext, widget, imageChunkEvent) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      child: const CircularProgressIndicator(
                        color: Color(ColorCode.primaryColor),
                      ));
                }, errorBuilder: (buildContext, object, stackTrace) {
                  return Image.asset(ImagePath.imageDownloadError);
                }, imageUrl))));
  }
}
