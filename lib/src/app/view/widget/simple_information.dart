import 'package:flexurio_erp_core/src/app/view/widget/row_fields.dart';
import 'package:flexurio_erp_core/src/app/view/widget/tile_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SimpleInformation extends StatelessWidget {
  const SimpleInformation({
    required this.data,
    super.key,
  });

  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var first = true;
    for (final row in data) {
      final column = <Widget>[];
      for (final entry in row.entries) {
        column.add(
          TileDataVertical(
            label: entry.key,
            child: Text(entry.value),
          ),
        );
      }
      children.add(RowFields(children: column));
      if (first) {
        first = false;
        continue;
      }
      children.add(const Gap(5));
    }

    return Column(
      children: children,
    );
  }
}
