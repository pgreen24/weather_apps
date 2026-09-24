import 'package:flutter/material.dart';
class HomeMainImageView extends StatelessWidget {
  const HomeMainImageView({
    required this.imagePath,
    this.imageWidth = 200,
    this.imageHeight = 200,
    super.key,
  });

  final String imagePath;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath, width: imageWidth, height: imageHeight);
  }
}