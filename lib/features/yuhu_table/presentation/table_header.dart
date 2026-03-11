import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class TableHeader<T> extends StatelessWidget {
  const TableHeader({
    required this.column,
    required this.isSort,
    required this.ascending,
    super.key,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.modeCondition(
                    const Color(0xff374259),
                    Colors.blueGrey.shade200,
                  ),
                ),
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
