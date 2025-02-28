import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SwitchLanguage extends StatefulWidget {
  const SwitchLanguage({super.key});

  @override
  State<SwitchLanguage> createState() => _SwitchLanguageState();
}

class _SwitchLanguageState extends State<SwitchLanguage> {
  late Box<String> settings;
  Locale locale = const Locale('en');

  @override
  void initState() {
    super.initState();

    () async {
      settings = await Hive.openBox<String>('settings');
      final languageCode = settings.get('language');
      if (languageCode != null && locale.languageCode != languageCode) {
        setState(() {
          locale = Locale(languageCode);
        });
      }
    }();
  }

  void onChanged(Locale value) {
    locale = value;
    context.setLocale(locale);
    settings.put('language', locale.languageCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Language(
          state: locale,
          locale: const Locale('en'),
          onTap: onChanged,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 1,
          height: 20,
          color: Colors.blueGrey.shade400,
        ),
        _Language(
          state: locale,
          locale: const Locale('id'),
          onTap: onChanged,
        ),
      ],
    );
  }
}

class _Language extends StatelessWidget {
  const _Language({
    required this.state,
    required this.locale,
    required this.onTap,
  });

  final Locale state;
  final Locale locale;
  final void Function(Locale locale) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isSelected = state.languageCode == locale.languageCode;
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          locale.languageCode.toUpperCase(),
          style: isSelected
              ? TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                )
              : null,
        ),
      ),
      onTap: () => onTap(locale),
    );
  }
}
