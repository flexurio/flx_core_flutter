import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

Color dropDownSmallForegroundColor(ThemeData theme) {
  return theme.modeCondition(
    Colors.blueGrey.shade700,
    Colors.blueGrey.shade200,
  );
}

class ContainerDropDown<T> extends StatelessWidget {
  const ContainerDropDown({
    required this.builder,
    required this.status,
    required this.showSelectedItems,
    super.key,
    this.width,
  });

  final double? width;
  final Status status;
  final bool showSelectedItems;

  final Widget Function(
    Color foregroundColor,
    OutlineInputBorder border,
    DropdownButtonProps dropdownButtonProps,
    PopupProps<T> popupProps,
    DropDownDecoratorProps decoratorProps,
  ) builder;

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

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor),
    );
    final foregroundColor = dropDownSmallForegroundColor(theme);

    final dropdownButtonProps = DropdownButtonProps(
      iconClosed: icon,
      iconOpened: icon,
      padding: EdgeInsets.zero,
      iconSize: 18,
      color: foregroundColor,
    );

    final popupProps = PopupProps<T>.menu(
      showSelectedItems: showSelectedItems,
      searchDelay: Duration.zero,
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
        style: TextStyle(color: theme.modeCondition(null, Colors.white70)),
        decoration: InputDecoration(
          hintText: '${'search'.tr()}...',
          enabledBorder: border,
          border: border,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );

    const decoratorProps = DropDownDecoratorProps(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
      ),
    );

    return Container(
      width: width,
      height: isPlatformMobile() ? 36 : 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
        color: theme.cardColor,
      ),
      child: builder(
        foregroundColor,
        border,
        dropdownButtonProps,
        popupProps,
        decoratorProps,
      ),
    );
  }
}
