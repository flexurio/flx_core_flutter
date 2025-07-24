
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/view/widget/yuhu_table/table_column.dart';

class TableHeader<T> extends StatelessWidget {
  const TableHeader({
    required this.column,
    required this.isSort,
    required this.ascending,
    this.onTap,
  });

  final TableColumn<T> column;
  final void Function()? onTap;
  final bool isSort;
  final bool ascending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: column.alignment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                column.title,
                style:
                TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
              ),
              if (isSort)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    ascending ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: primaryColor.withAlpha(120),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
