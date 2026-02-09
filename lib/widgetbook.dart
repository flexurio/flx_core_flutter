import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
// Import the generated file
import 'package:flx_core_flutter/widgetbook.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // Use the generated directories variable
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: MyTheme.getTheme(Colors.blue, ThemeMode.light),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: MyTheme.getTheme(Colors.blue, ThemeMode.dark),
            ),
          ],
        ),
      ],
    );
  }
}
