
// import 'package:sparkd/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:tradelinkedai/core/extensions/app_theme_extension.dart';
import 'package:tradelinkedai/core/theme/app_theme.dart';

class ThemeLight extends AppTheme {
  ThemeData get theme => ThemeData(
        useMaterial3: true,
        primarySwatch: primarySwatch,
        extensions: [extension],
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardColor: cardColor,
        appBarTheme: const AppBarTheme(centerTitle: true),
        // fontFamily: FontFamily.poppins,
        colorScheme: ColorScheme.light(
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          error: errorColor,
        ),

        inputDecorationTheme: inputDecorationTheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(),
      );

  @override
  MaterialColor get primarySwatch => createMaterialColor(primary);

  @override
  Color get primary => Color.fromARGB(255, 48, 48, 244);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get secondary => const Color(0xFFC70101);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  @override
  Color get scaffoldBackgroundColor => Colors.white;

  @override
  Color get errorColor => Colors.red;

  @override
  TextTheme get textTheme => const TextTheme(

  );

  @override
  AppThemeExtension get extension => AppThemeExtension(
        extraLightGrey: Colors.grey.withOpacity(0.3),
        lightGrey: Colors.grey.withOpacity(0.7),
        vertical: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primary, secondary],
        ),
        horizontal: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [primary, secondary],
        ),
        grey: grey,
    chatBubbleColor: chatBubbleColor
      );

  @override
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds.abs()).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds.abs()).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds.abs()).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        errorStyle: textTheme.bodySmall?.copyWith(color: errorColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor),
        ),
      );

  @override
  Color get cardColor => const Color(0xFFFFEFE2);

  @override
  Color get grey => const Color(0xffBEBFC2);

  @override
  Color get chatBubbleColor => const Color(0xffFAE3D1);
}
