import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension ThemeDataExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  T modeCondition<T>(T light, T dark) => isDark ? dark : light;
}

class MyTheme {
  static final textTheme = GoogleFonts.nunitoTextTheme();

  static const black00dp = Color(0XFF050505);
  static const black01dp = Color(0XFF131517);
  static const black02dp = Color(0XFF1e1f25);
  static const black03dp = Color(0XFF212121);
  static const black04dp = Color(0XFF242424);
  static const black06dp = Color.fromARGB(255, 40, 42, 50);
  static const black08dp = Color(0XFF2d2d2d);
  static const black12dp = Color(0XFF323232);
  static const black16dp = Color.fromARGB(255, 56, 59, 72);
  static const black24dp = Color(0XFF373737);

  static ThemeData getTheme(Color primaryColor, ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    final theme = isDark ? ThemeData.dark() : ThemeData();
    final dividerColor = isDark ? MyTheme.black06dp : Colors.grey.shade200;

    final color = isDark
        ? const Color.fromARGB(255, 146, 148, 165)
        : const Color.fromARGB(255, 91, 97, 118);
    return theme.copyWith(
      cardColor: isDark ? black02dp : Colors.white,
      primaryColor: Colors.white,
      colorScheme: theme.colorScheme.copyWith(
        primary: primaryColor,
        secondary: Colors.orange,
        surfaceTint: Colors.transparent,
        surface: Colors.white,
      ),
      tooltipTheme: isDark
          ? theme.tooltipTheme.copyWith(
              decoration: BoxDecoration(
                color: black00dp.withOpacity(.8),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              textStyle: const TextStyle(color: Colors.white70),
            )
          : null,
      iconTheme: IconThemeData(
        color: isDark
            ? const Color(0XFF5A5E80)
            : const Color.fromARGB(255, 91, 97, 118),
      ),
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: color,
        ),
      ),
      shadowColor: Colors.black38,
      dividerTheme: DividerThemeData(space: 0, color: dividerColor),
      dividerColor: dividerColor,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? black02dp : Colors.white,
      ),
      scaffoldBackgroundColor: isDark ? black01dp : const Color(0XFFf3f4f8),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 18, horizontal: 36),
          ),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueGrey[900]),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: Colors.blueGrey[900],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
