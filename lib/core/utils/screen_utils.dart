
import 'package:flutter/material.dart';

class ScreenUtils {
  static late ScreenUtils _instance;

  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? bottomPadding;
  static EdgeInsets? padding;
  factory ScreenUtils() {
    return _instance;
  }

  ScreenUtils._();

  static void init(BuildContext context) {
    _instance = ScreenUtils._();

    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    padding = _mediaQueryData!.padding;
  }
}