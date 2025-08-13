import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class SelectChip<T> extends StatefulWidget {
  const SelectChip({
    required this.options,
    required this.onChanged,
    required this.getLabel,
    this.value,
    this.axis = Axis.horizontal,
    this.isOutlined = false,
    super.key,
  });

  final T? value;
  final List<T> options;
  final void Function(T?) onChanged;
  final String Function(T) getLabel;
  final Axis axis;
  final bool isOutlined;

  @override
  State<SelectChip<T>> createState() => _SelectChipState<T>();
}

class _SelectChipState<T> extends State<SelectChip<T>> {
  T? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final option in widget.options) {
      final label = widget.getLabel(option);
      final selectedValue =
          label == (selected != null ? widget.getLabel(selected!) : null);
      final onPressed = () {
        setState(() {
          if (option != selected) {
            selected = option;
          } else {
            selected = null;
          }
          widget.onChanged(selected);
        });
      };
      children.add(
        widget.isOutlined
            ? _Chip(
                label: label,
                selected: selectedValue,
                onPressed: onPressed,
              )
            : _ChipSolid(
                label: label,
                selected: selectedValue,
                onPressed: onPressed,
              ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: widget.axis == Axis.horizontal ? 50 : null,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: widget.axis,
          itemCount: children.length,
          itemBuilder: (context, index) {
            return children[index];
          },
          separatorBuilder: (context, index) {
            return const Gap(6);
          },
        ),
      ),
    );
  }
}

class SelectChipField<T> extends FormField<String> {
  SelectChipField({
    required this.label,
    required this.controller,
    required this.options,
    required this.onChanged,
    required this.getLabel,
    this.enabled = true,
    super.key,
    super.validator,
  }) : super(
          initialValue: controller.text,
          builder: (field) {
            final children = <Widget>[];
            for (final option in options) {
              final label = getLabel(option);
              children.add(
                _Chip(
                  label: label.tr(),
                  selected: label == field.value,
                  onPressed: enabled
                      ? () {
                          field.setValue(label);
                          controller.text = label;
                          onChanged(option);
                          field.setState(() {});
                        }
                      : null,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const Gap(6),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: children,
                      ),
                    ),
                  ],
                ),
                ErrorTextField(errorText: field.errorText),
              ],
            );
          },
        );
  @override
  final bool enabled;
  final String label;
  final TextEditingController controller;
  final List<T> options;
  final void Function(T value) onChanged;
  final String Function(T) getLabel;
}

class _Chip extends StatelessWidget {
  const _Chip({
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
          color: selected ? theme.colorScheme.primary.withOpacity(.1) : null,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.modeCondition(
                    Colors.grey.shade300,
                    Colors.grey.shade800,
                  ),
          ),
        ),
        // child: Text(label),
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

class _ChipSolid extends StatelessWidget {
  const _ChipSolid({
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
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: selected ? theme.colorScheme.primary : Colors.white,
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 5,
                    color: theme.colorScheme.primary.withOpacity(.6),
                  ),
                ]
              : null,
        ),
        // child: Text(label),
        duration: const Duration(milliseconds: 200),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
