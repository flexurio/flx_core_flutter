import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_small.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: DropDownSmall,
)
Widget dropDownSmallDefault(BuildContext context) {
  return Scaffold(
    body: Center(
      child: DropDownSmall<String>(
        labelText: 'Select an option',
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Initial Value',
  type: DropDownSmall,
)
Widget dropDownSmallWithInitialValue(BuildContext context) {
  return Scaffold(
    body: Center(
      child: DropDownSmall<String>(
        labelText: 'Select an option',
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        initialValue: 'Option 2',
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Icon',
  type: DropDownSmall,
)
Widget dropDownSmallWithIcon(BuildContext context) {
  return Scaffold(
    body: Center(
      child: DropDownSmall<String>(
        labelText: 'Select an option',
        icon: Icons.filter_list,
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Clear Button',
  type: DropDownSmall,
)
Widget dropDownSmallWithClearButton(BuildContext context) {
  return Scaffold(
    body: Center(
      child: DropDownSmall<String>(
        labelText: 'Select an option',
        initialValue: 'Option 1',
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        onChanged: (value) {},
        onClear: () {},
      ),
    ),
  );
}
