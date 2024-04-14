import 'dart:io';

import 'package:budgetopia/common/constantes/double.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final class LightTheme {
  static final ThemeData _default = FlexThemeData.light(
    appBarBackground: const Color(0xFFB5F2B0),
    //scaffoldBackground: const Color(0xff008dbb),
    scheme: FlexScheme.jungle,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 40,
    subThemesData: FlexSubThemesData(
      blendOnLevel: 22,
      blendOnColors: false,
      useTextTheme: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      splashType: FlexSplashType.inkRipple,
      appBarCenterTitle: !Platform.isIOS,
      buttonMinSize: const Size(Double.CEM, Double.CINQUENTA),
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: Double.VINTE,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorBorderWidth: Double.UM,
      inputDecoratorFillColor: const Color(0xFFebffe5),
      thinBorderWidth: Double.DOIS,
      appBarScrolledUnderElevation: Double.ZERO,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.tertiary,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepTertiaryContainer: true,
    ),
    tones: FlexTones.vividSurfaces(Brightness.light),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      },
    ),
    // To use the Playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  static Color _getColorSegmentedButton(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{MaterialState.selected};
    if (states.any(interactiveStates.contains)) {
      return _default.colorScheme.tertiary;
    }
    return _default.colorScheme.onPrimary;
  }

  static Color _getColorSegmentedButtonIcon(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{MaterialState.selected};
    if (states.any(interactiveStates.contains)) {
      return _default.colorScheme.onPrimary;
    }
    return _default.colorScheme.primary;
  }

  static ThemeData getTheme() {
    return _default.copyWith(
      textTheme: _default.textTheme.copyWith(
        bodySmall: _default.textTheme.bodySmall!.copyWith(color: _default.colorScheme.onTertiaryContainer),
        bodyMedium: _default.textTheme.bodyMedium!.copyWith(color: _default.colorScheme.onTertiaryContainer),
        bodyLarge: _default.textTheme.bodyLarge!.copyWith(color: _default.colorScheme.onTertiaryContainer),
      ),
      segmentedButtonTheme: _default.segmentedButtonTheme.copyWith(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(_getColorSegmentedButton),
          iconColor: MaterialStateProperty.resolveWith(_getColorSegmentedButtonIcon),
          animationDuration: const Duration(seconds: 2),
        ),
      ),
      floatingActionButtonTheme: _default.floatingActionButtonTheme.copyWith(backgroundColor: _default.colorScheme.tertiary),
    );
  }
}
