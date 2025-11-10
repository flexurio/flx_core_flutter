import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class DropDownSmall<T> extends StatefulWidget {
  const DropDownSmall({
    required this.labelText,
    required this.itemAsString,
    required this.items,
    required this.onChanged,
    super.key,
    this.icon,
    this.initialValue,
  });
  final String Function(T) itemAsString;
  final List<T> items;
  final String labelText;
  final T? initialValue;
  final IconData? icon;

  final void Function(T?)? onChanged;

  @override
  State<DropDownSmall<T>> createState() => _DropDownSmallState<T>();
}

Color dropDownSmallForegroundColor(ThemeData theme) {
  return theme.modeCondition(
    Colors.blueGrey.shade700,
    Colors.blueGrey.shade200,
  );
}

class _DropDownSmallState<T> extends State<DropDownSmall<T>> {
  late String label;

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

    return PopupMenuButton<T>(
      onSelected: (T value) {
        widget.onChanged?.call(value);
        setState(() {
          label = widget.itemAsString(value);
        });
      },
      itemBuilder: (BuildContext context) => widget.items
          .map(
            (item) => PopupMenuItem<T>(
              value: item,
              child: Text(widget.itemAsString(item)),
            ),
          )
          .toList(),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: AbsorbPointer(
        child: DropDownSmallButton(
          icon: widget.icon,
          label: label,
          onPressed: () {},
        ),
      ),
    );
  }
}

enum Status {
  progress(0),
  error(-1),
  loaded(1);

  const Status(this.value);

  final int value;

  bool get isProgress => this == Status.progress;
  bool get isError => this == Status.error;
  bool get isLoaded => this == Status.loaded;
}

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
            Colors.blueGrey.shade100.withOpacity(.8),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Gap(4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownSearch<T>.multiSelection(
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
                    isSelected
                        ? Icons.check_box_outlined
                        : Icons.square_outlined,
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
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
              ),
            ),
            onSelected: onChanged,
            dropdownBuilder: dropdownBuilder,
            selectedItems: selectedItems,
          ),
        ),
      ],
    );
  }
}

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
    return _ContainerDropDown<T>(
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
    return _ContainerDropDown<T>(
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

class _ContainerDropDown<T> extends StatelessWidget {
  const _ContainerDropDown({
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
