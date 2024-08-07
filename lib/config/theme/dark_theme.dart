import 'dart:io';

import 'package:budgetopia/common/constantes/double.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final class DarkTheme {
  static final ThemeData _default = FlexThemeData.dark(
    appBarBackground: const Color(0xFF003824),
    colors: const FlexSchemeColor(
      primary: Color(0xff629f80),
      primaryContainer: Color(0xff274033),
      secondary: Color(0xff81b39a),
      secondaryContainer: Color(0xff4d6b5c),
      tertiary: Color(0xff88c5a6),
      tertiaryContainer: Color(0xff356c50),
      appBarColor: Color(0xff356c50),
      error: Color(0xffcf6679),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 29,
    subThemesData: FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      splashType: FlexSplashType.inkRipple,
      adaptiveElevationShadowsBack: const FlexAdaptive.all(),
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      appBarCenterTitle: !Platform.isIOS,
      buttonMinSize: const Size(Double.CEM, Double.CINQUENTA),
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: Double.VINTE,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorBorderWidth: Double.UM,
      inputDecoratorFillColor: const Color(0xFF002215),
      thinBorderWidth: Double.DOIS,
      appBarScrolledUnderElevation: Double.ZERO,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.secondary,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepTertiaryContainer: true,
    ),
    tones: FlexTones.vividSurfaces(Brightness.dark),
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

  static Color _getColorSegmentedButton(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{WidgetState.selected};
    if (states.any(interactiveStates.contains)) {
      return _default.colorScheme.secondary;
    }
    return _default.colorScheme.onPrimary;
  }

  static Color _getColorSegmentedButtonIcon(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{WidgetState.selected};
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
          backgroundColor: WidgetStateProperty.resolveWith(_getColorSegmentedButton),
          iconColor: WidgetStateProperty.resolveWith(_getColorSegmentedButtonIcon),
          animationDuration: const Duration(seconds: 2),
        ),
      ),
      floatingActionButtonTheme: _default.floatingActionButtonTheme.copyWith(backgroundColor: _default.colorScheme.secondary),
    );
  }
}
