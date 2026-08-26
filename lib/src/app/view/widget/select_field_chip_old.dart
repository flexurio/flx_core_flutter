import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

@Deprecated('use `SelectChipField(...)` ')
class SelectChipFieldOld extends FormField<String> {
  @Deprecated('use `SelectChipField(...)` ')
  SelectChipFieldOld({
    required this.label,
    required this.controller,
    required this.options,
    super.key,
    super.validator,
  }) : super(
          initialValue: controller.text,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(label),
                    ),
                    const Gap(24),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final option in options)
                            _SelectChip(
                              label: option,
                              selected: option == field.value,
                              onPressed: () {
                                field.didChange(option);
                                controller.text = option;
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                ErrorTextField(errorText: field.errorText),
              ],
            );
          },
        );
  final String label;
  final TextEditingController controller;
  final List<String> options;
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : null,
          border: Border.all(
            color: selected ? theme.colorScheme.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? theme.colorScheme.primary : null,
          ),
        ),
      ),
    );
  }
}
