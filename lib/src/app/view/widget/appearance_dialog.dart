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
  bool _isExpanded = false;

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
      width: 540,
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
          // Trigger Bar
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: theme.modeCondition(
                  const Color(0xFFF7F2F4),
                  theme.cardColor.lighten(0.05),
                ),
                borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _selectedDisplay.icon,
                      color: primaryColor,
                      size: 22,
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
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Gap(16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    display: SidebarMenuDisplay.iconsOnly,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildOptionCard(
                    context,
                    display: SidebarMenuDisplay.iconsAndLabels,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required SidebarMenuDisplay display,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isSelected = _selectedDisplay == display;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _selectedDisplay = display;
        });
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.modeCondition(
                  const Color(0xFFF9EFF3),
                  primaryColor.withValues(alpha: 0.12),
                )
              : theme.modeCondition(
                  Colors.white,
                  theme.cardColor,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : theme.modeCondition(
                    const Color(0xFFE5E7EB),
                    Colors.white12,
                  ),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.12)
                        : theme.modeCondition(
                            const Color(0xFFF1F5F9),
                            Colors.white10,
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    display.icon,
                    color: isSelected
                        ? primaryColor
                        : theme.modeCondition(
                            const Color(0xFF64748B),
                            Colors.grey,
                          ),
                    size: 22,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                else
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.modeCondition(
                          const Color(0xFF94A3B8),
                          Colors.grey.shade600,
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(16),
            Text(
              display.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              display.description,
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.6) ??
                    Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
