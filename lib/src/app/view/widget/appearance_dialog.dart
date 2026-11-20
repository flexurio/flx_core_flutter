import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

Future<void> showAppearanceDialog({
  required BuildContext context,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => const AppearanceDialog(),
  );
}

class AppearanceDialog extends StatefulWidget {
  const AppearanceDialog({super.key});

  @override
  State<AppearanceDialog> createState() => _AppearanceDialogState();
}

class _AppearanceDialogState extends State<AppearanceDialog> {
  late SidebarMenuDisplay _selectedDisplay;

  @override
  void initState() {
    super.initState();
    _selectedDisplay = SidebarMenuDisplayBloc.instance.state;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return CardForm(
      popup: true,
      title: 'Appearance',
      icon: Icons.tune,
      width: 500,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'cancel'.tr() != 'cancel' ? 'cancel'.tr() : 'Cancel',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            SidebarMenuDisplayBloc.instance.add(_selectedDisplay);
            Navigator.pop(context);
          },
          child: Text(
            'save'.tr() != 'save' ? 'save'.tr() : 'Save',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sidebar Menu Display',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Text(
            'Choose whether to show or hide the menu names in the sidebar',
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.6) ??
                  Colors.grey,
            ),
          ),
          const Gap(16),
          PopupMenuButton<SidebarMenuDisplay>(
            tooltip: '',
            offset: const Offset(0, 68),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (display) {
              setState(() {
                _selectedDisplay = display;
              });
            },
            itemBuilder: (context) => [
              _buildMenuItem(
                context,
                display: SidebarMenuDisplay.iconsAndLabels,
                isSelected:
                    _selectedDisplay == SidebarMenuDisplay.iconsAndLabels,
              ),
              _buildMenuItem(
                context,
                display: SidebarMenuDisplay.iconsOnly,
                isSelected: _selectedDisplay == SidebarMenuDisplay.iconsOnly,
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.modeCondition(
                  const Color(0xFFF7F2F4),
                  theme.cardColor.lighten(0.05),
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.modeCondition(
                    const Color(0xFFEADBDF),
                    Colors.white12,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.format_indent_decrease_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedDisplay.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedDisplay.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.6) ??
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<SidebarMenuDisplay> _buildMenuItem(
    BuildContext context, {
    required SidebarMenuDisplay display,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return PopupMenuItem<SidebarMenuDisplay>(
      value: display,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: isSelected ? 0.15 : 0.08,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.format_indent_decrease_rounded,
                color: isSelected ? primaryColor : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    display.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? primaryColor : null,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    display.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.6) ??
                          Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, size: 18, color: primaryColor),
            ],
          ],
        ),
      ),
    );
  }
}
