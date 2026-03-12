import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
// Import the generated file
import 'package:flx_core_flutter/widgetbook.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize flavorConfig for widgets that depend on it (like LogoNamed)
  flavorConfig = FlavorConfig(
    companyId: 'chiron',
    companyName: 'Chiron',
    companyPhone: '-',
    companyWebsite: '-',
    companyAddress: '-',
    apiUrl: '-',
    color: Colors.blue,
    colorSoft: Colors.blue.withOpacity(0.1),
    backgroundLoginPage: '',
    applicationConfig: null,
  );

  await storageInit(flavorConfig.companyId);

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
        LocalizationAddon(
          locales: [
            const Locale('en', 'US'),
            const Locale('id', 'ID'),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.android.samsungGalaxyS20,
            Devices.windows.laptop,
          ],
        ),
      ],
    );
  }
}
