import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/_container_drop_down.dart';
import 'package:gap/gap.dart';

class FDropDownSearchSmallMultiple<T> extends StatelessWidget {
  const FDropDownSearchSmallMultiple({
    required this.labelText,
    required this.itemAsString,
    required this.items,
    required this.iconField,
    required this.initialValue,
    this.width,
    super.key,
    this.status = Status.loaded,
    this.compareFn,
    this.showSelectedItems = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final void Function(List<T>)? onChanged;
  final String labelText;
  final List<T> initialValue;
  final List<T> items;
  final double? width;
  final Status status;
  final String? Function(List<T>?)? validator;
  final String Function(T) itemAsString;
  final bool Function(T, T)? compareFn;
  final bool showSelectedItems;
  final bool enabled;
  final IconData iconField;

  @override
  Widget build(BuildContext context) {
    return ContainerDropDown<T>(
      key: UniqueKey(),
      builder: (
        foregroundColor,
        border,
        dropdownButtonProps,
        popupProps,
        decoratorProps,
      ) {
        return DropdownSearch<T>.multiSelection(
          validator: validator,
          compareFn: compareFn ?? (a, b) => a == b,
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: dropdownButtonProps,
          ),
          // popupProps: popupProps,
          items: (f, p) => items,
          itemAsString: itemAsString,
          dropdownBuilder: (context, selectedItem) {
            return Row(
              children: [
                const Gap(12),
                Icon(iconField, size: 16, color: foregroundColor),
                const Gap(18),
                Expanded(
                  child: Text(
                    selectedItem.isEmpty
                        ? '${'choose'.tr()} $labelText'
                        : selectedItem.map(itemAsString).join(', '),
                    style: TextStyle(color: foregroundColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
          decoratorProps: decoratorProps,
          onSelected: onChanged,
          selectedItems: initialValue,
          enabled: enabled,
        );
      },
      status: status,
      width: width,
      showSelectedItems: showSelectedItems,
    );
  }
}
