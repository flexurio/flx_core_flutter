import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class DropDownSmall<T> extends StatefulWidget {
  const DropDownSmall({
    required this.labelText,
    required this.itemAsString,
    required this.items,
    required this.onChanged,
    super.key,
    this.icon,
    this.initialValue,
    this.onClear,
  });
  final String Function(T) itemAsString;
  final List<T> items;
  final String labelText;
  final T? initialValue;
  final IconData? icon;
  final VoidCallback? onClear;

  final void Function(T?)? onChanged;

  @override
  State<DropDownSmall<T>> createState() => _DropDownSmallState<T>();
}

class _DropDownSmallState<T> extends State<DropDownSmall<T>> {
  late String label;
  final GlobalKey<PopupMenuButtonState<T>> _popupKey =
      GlobalKey<PopupMenuButtonState<T>>();

  @override
  void initState() {
    super.initState();
    label = '${'choose'.tr()} ${widget.labelText}';
    if (widget.initialValue != null) {
      label = widget.itemAsString(widget.initialValue as T);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validItems = widget.items.whereType<T>().toList();

    if (validItems.length <= 1) {
      return IgnorePointer(
        child: DropDownSmallButton(
          icon: widget.icon,
          label: label,
          onPressed: () {},
          onClear: widget.onClear,
        ),
      );
    }

    return PopupMenuButton<T>(
      key: _popupKey,
      onSelected: (T value) {
        widget.onChanged?.call(value);
        setState(() {
          label = widget.itemAsString(value);
        });
      },
      itemBuilder: (BuildContext context) => validItems
          .map(
            (item) => PopupMenuItem<T>(
              value: item,
              child: Text(widget.itemAsString(item)),
            ),
          )
          .toList(),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: DropDownSmallButton(
        icon: widget.icon,
        label: label,
        onPressed: () {
          _popupKey.currentState?.showButtonMenu();
        },
        onClear: widget.onClear,
      ),
    );
  }
}
