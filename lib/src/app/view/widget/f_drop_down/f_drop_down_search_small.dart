import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/_container_drop_down.dart';
import 'package:gap/gap.dart';

class FDropDownSearchSmall<T> extends StatelessWidget {
  const FDropDownSearchSmall({
    required this.labelText,
    required this.itemAsString,
    required this.items,
    required this.iconField,
    this.width,
    super.key,
    this.status = Status.loaded,
    this.initialValue,
    this.compareFn,
    this.showSelectedItems = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.showClearButton = false,
  });

  final void Function(T?)? onChanged;
  final String labelText;
  final T? initialValue;
  final List<T> items;
  final double? width;
  final Status status;
  final String? Function(T?)? validator;
  final String Function(T) itemAsString;
  final bool Function(T, T)? compareFn;
  final bool showSelectedItems;
  final bool enabled;
  final IconData iconField;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) {
    return ContainerDropDown<T>(
      builder: (
        foregroundColor,
        border,
        dropdownButtonProps,
        popupProps,
        decoratorProps,
      ) {
        return DropdownSearch<T>(
          validator: validator,
          compareFn: compareFn ?? (a, b) => a == b,
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: dropdownButtonProps,
            clearButtonProps: ClearButtonProps(
              icon: const Icon(Icons.clear, size: 14),
              isVisible: showClearButton,
            ),
          ),
          popupProps: popupProps,
          items: (f, p) => items,
          itemAsString: itemAsString,
          dropdownBuilder: (context, selectedItem) {
            return Row(
              children: [
                const Gap(12),
                Icon(iconField, size: 16, color: foregroundColor),
                const Gap(18),
                Text(
                  selectedItem == null
                      ? '${'choose'.tr()} $labelText'
                      : itemAsString(selectedItem),
                  style: TextStyle(color: foregroundColor),
                ),
              ],
            );
          },
          decoratorProps: decoratorProps,
          onSelected: onChanged,
          selectedItem: initialValue,
          enabled: enabled,
        );
      },
      status: status,
      width: width,
      showSelectedItems: showSelectedItems,
    );
  }
}
