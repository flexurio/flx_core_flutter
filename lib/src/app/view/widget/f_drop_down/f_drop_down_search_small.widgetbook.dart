import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_search_small.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: FDropDownSearchSmall,
)
Widget fDropDownSearchSmallDefault(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FDropDownSearchSmall<String>(
        labelText: 'Select an option',
        iconField: Icons.search,
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Initial Value',
  type: FDropDownSearchSmall,
)
Widget fDropDownSearchSmallWithInitialValue(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FDropDownSearchSmall<String>(
        labelText: 'Select an option',
        iconField: Icons.search,
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        initialValue: 'Option 2',
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Clear Button',
  type: FDropDownSearchSmall,
)
Widget fDropDownSearchSmallWithClearButton(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FDropDownSearchSmall<String>(
        labelText: 'Select an option',
        iconField: Icons.search,
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        initialValue: 'Option 1',
        showClearButton: true,
        onChanged: (value) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: FDropDownSearchSmall,
)
Widget fDropDownSearchSmallDisabled(BuildContext context) {
  return Scaffold(
    body: Center(
      child: FDropDownSearchSmall<String>(
        labelText: 'Select an option',
        iconField: Icons.search,
        itemAsString: (item) => item,
        items: const ['Option 1', 'Option 2', 'Option 3'],
        initialValue: 'Option 1',
        enabled: false,
        onChanged: (value) {},
      ),
    ),
  );
}
