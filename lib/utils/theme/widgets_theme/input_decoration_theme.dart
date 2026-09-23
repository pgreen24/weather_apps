import 'package:flutter/material.dart';
import '../../app_size.dart';
import '../../apps_color.dart';

class WInputDecorationTheme {
  WInputDecorationTheme._();

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(WSizes.inputFieldRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

    prefixIconColor: AppsColor.darkGrey,
    suffixIconColor: AppsColor.darkGrey,

    hintStyle: TextStyle(
      fontSize: WSizes.fontSizeSm,
      color: AppsColor.darkGrey.withValues(alpha: 0.7),
    ),

    labelStyle: TextStyle(
      fontSize: WSizes.fontSizeMd,
      color: AppsColor.darkGrey,
    ),

    floatingLabelStyle: TextStyle(
      fontSize: WSizes.fontSizeSm,
      color: AppsColor.black,
      fontWeight: FontWeight.w500,
    ),

    errorStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    // Borders
    border: _border(AppsColor.darkGrey),

    enabledBorder: _border(AppsColor.darkGrey.withValues(alpha: 0.6)),

    focusedBorder: _border(AppsColor.black, width: 1.5),

    errorBorder: _border(AppsColor.error),

    focusedErrorBorder: _border(AppsColor.error, width: 1.5),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

    prefixIconColor: AppsColor.lightGrey,
    suffixIconColor: AppsColor.lightGrey,

    hintStyle: TextStyle(
      fontSize: WSizes.fontSizeSm,
      color: AppsColor.lightGrey.withValues(alpha: 0.9),
    ),

    labelStyle: TextStyle(
      fontSize: WSizes.fontSizeMd,
      color: AppsColor.lightGrey,
    ),

    floatingLabelStyle: TextStyle(
      fontSize: WSizes.fontSizeSm,
      color: AppsColor.white,
      fontWeight: FontWeight.w500,
    ),

    errorStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),

    // Borders
    border: _border(AppsColor.whiteGray),

    enabledBorder: _border(AppsColor.whiteGray.withValues(alpha: 0.5)),

    focusedBorder: _border(AppsColor.whiteGray, width: 1.5),

    errorBorder: _border(AppsColor.error),

    focusedErrorBorder: _border(AppsColor.error, width: 1.5),
  );
}