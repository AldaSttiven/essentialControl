import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgUtil {
  SvgPicture buildSvgPicture(String path, Color color, double size) {
    return SvgPicture.asset(
      path,
      width: size,
      allowDrawingOutsideViewBox: true,
      color: color,
    );
  }

  SvgPicture buildSvgPictureOutColor(String path, double size) {
    return SvgPicture.asset(
      path,
      width: size,
      allowDrawingOutsideViewBox: true,
    );
  }
}
