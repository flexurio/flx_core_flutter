import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class FDropDownSearch<T> extends StatelessWidget {
  const FDropDownSearch({
    required this.labelText,
    required this.itemAsString,
    required this.items,
    super.key,
    this.status = Status.loaded,
    this.initialValue,
    this.compareFn,
    this.showSelectedItems = false,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final void Function(T?)? onChanged;
  final String? labelText;
  final T? initialValue;
  final List<T> items;
  final Status status;
  final String? Function(T?)? validator;
  final String Function(T) itemAsString;
  final bool Function(T, T)? compareFn;
  final bool showSelectedItems;
  final bool enabled;

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
    final backgroundColor = enabled
        ? theme.modeCondition(
            theme.cardColor,
            MyTheme.black00dp,
          )
        : theme.modeCondition(
            Colors.blueGrey.shade100.withValues(alpha: .8),
            MyTheme.black02dp,
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
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Gap(4),
        ],
        DropdownSearch<T>(
          validator: validator,
          compareFn: compareFn ?? (a, b) => a == b,
          suffixProps: DropdownSuffixProps(
            dropdownButtonProps: DropdownButtonProps(
              iconClosed: icon,
              iconOpened: icon,
            ),
          ),
          popupProps: PopupProps.menu(
            showSelectedItems: showSelectedItems,
            searchDelay: Duration.zero,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              style: TextStyle(
                color: theme.modeCondition(null, Colors.white70),
              ),
              decoration: InputDecoration(
                hintText: '${'search'.tr()}...',
                border: border,
                filled: true,
                fillColor: backgroundColor,
                enabledBorder: border,
                disabledBorder: border,
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
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
              enabledBorder: border,
              disabledBorder: border,
              errorBorder: borderError,
              border: border,
              filled: true,
              fillColor: backgroundColor,
            ),
          ),
          onSelected: onChanged,
          selectedItem: initialValue,
          enabled: enabled,
        ),
      ],
    );
  }
}
