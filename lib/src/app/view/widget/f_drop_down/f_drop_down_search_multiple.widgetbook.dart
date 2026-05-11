import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_search_multiple.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: FDropDownSearchMultiple,
)
Widget fDropDownSearchMultipleDefault(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FDropDownSearchMultiple<String>(
        labelText: 'Select Options',
        itemAsString: (item) => item,
        status: Status.loaded,
        items: const ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        selectedItems: const [],
        onChanged: (values) {},
        dropdownBuilder: (context, selectedItems) {
          return Text(
            selectedItems.isEmpty
                ? 'Select an option'
                : selectedItems.join(', '),
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Selected Items',
  type: FDropDownSearchMultiple,
)
Widget fDropDownSearchMultipleWithSelected(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FDropDownSearchMultiple<String>(
        labelText: 'Select Options',
        itemAsString: (item) => item,
        status: Status.loaded,
        items: const ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        selectedItems: const ['Option 1', 'Option 3'],
        onChanged: (values) {},
        dropdownBuilder: (context, selectedItems) {
          return Text(
            selectedItems.isEmpty
                ? 'Select an option'
                : selectedItems.join(', '),
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading Status',
  type: FDropDownSearchMultiple,
)
Widget fDropDownSearchMultipleLoading(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FDropDownSearchMultiple<String>(
        labelText: 'Select Options',
        itemAsString: (item) => item,
        status: Status.progress,
        items: const [],
        selectedItems: const [],
        onChanged: (values) {},
        dropdownBuilder: (context, selectedItems) {
          return const Text('Loading...');
        },
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Error Status',
  type: FDropDownSearchMultiple,
)
Widget fDropDownSearchMultipleError(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: FDropDownSearchMultiple<String>(
        labelText: 'Select Options',
        itemAsString: (item) => item,
        status: Status.error,
        items: const [],
        selectedItems: const [],
        onChanged: (values) {},
        dropdownBuilder: (context, selectedItems) {
          return const Text('Error loading items');
        },
      ),
    ),
  );
}
