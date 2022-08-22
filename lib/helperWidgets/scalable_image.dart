import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class ScalableImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final num? height;
  final num? width;
  const ScalableImage(this.image,
      {Key? key, this.fit = BoxFit.contain, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pixelRatio = window.devicePixelRatio;
    final ratioList = [1, 2, 3];
    final nearestLarger = ratioList.reduce(
        (a, b) => (a - pixelRatio).abs() <= (b - pixelRatio).abs() ? a : b);
    final ext = image.split('.').last;
    final scale = nearestLarger == 1 ? '' : '@${nearestLarger}x';
    log('Image: ${image.replaceAll(ext, '$scale.$ext')}');
    log('px: $pixelRatio');
    return Image.asset(
      image.replaceAll('.$ext', '$scale.$ext'),
      fit: fit,
      height: height?.toDouble(),
      width: width?.toDouble(),
    );
  }
}
