import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class FDropDownSearchMultiple<T> extends StatelessWidget {
  const FDropDownSearchMultiple({
    required this.labelText,
    required this.itemAsString,
    required this.status,
    required this.items,
    required this.dropdownBuilder,
    required this.selectedItems,
    super.key,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.compareFn,
  });

  final String labelText;
  final T? initialValue;
  final List<T> items;
  final void Function(List<T>)? onChanged;
  final Status status;
  final String? Function(List<T>?)? validator;
  final String Function(T) itemAsString;
  final Widget Function(BuildContext, List<T>)? dropdownBuilder;
  final List<T> selectedItems;
  final bool Function(T, T)? compareFn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final Widget icon;

    switch (status) {
      case Status.error:
        icon = const Icon(Icons.error, color: Colors.red);
      case Status.progress:
        icon = const CupertinoActivityIndicator();
      case Status.loaded:
        icon = const Icon(Icons.keyboard_arrow_down_rounded, size: 24);
    }

    final borderColor = theme.modeCondition(
      Colors.blueGrey.shade100,
      const Color(0xff343640),
    );

    final backgroundColor = theme.modeCondition(
      theme.cardColor,
      MyTheme.black00dp,
    );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor),
    );

    final borderError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Gap(4),
        DropdownSearch<T>.multiSelection(
          compareFn: compareFn ?? (a, b) => a == b,
          validator: validator,
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: icon,
              iconOpened: icon,
            ),
          ),
          popupProps: MultiSelectionPopupProps.menu(
            checkBoxBuilder: (
              BuildContext context,
              T item,
              bool isDisabled,
              bool isSelected,
            ) {
              final theme = Theme.of(context);
              return Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Icon(
                  isSelected ? Icons.check_box_outlined : Icons.square_outlined,
                  color: theme.colorScheme.primary,
                ),
              );
            },
            searchDelay: Duration.zero,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              style: TextStyle(
                color: theme.modeCondition(null, Colors.white70),
              ),
              decoration: InputDecoration(
                hintText: '${'search'.tr()}...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          items: (f, p) => items,
          itemAsString: itemAsString,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: backgroundColor,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: borderError,
              border: border,
            ),
          ),
          onSelected: onChanged,
          dropdownBuilder: dropdownBuilder,
          selectedItems: selectedItems,
        ),
      ],
    );
  }
}
