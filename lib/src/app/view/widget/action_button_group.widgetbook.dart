import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Table Comparison',
  type: ActionsButton,
)
Widget actionsButtonTable(BuildContext context) {
  final theme = Theme.of(context);

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ActionsButton Scenarios',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A versatile button that opens a menu of contextual actions.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(200),
                    1: FlexColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _buildHeaderRow(context),
                    _buildRow(
                      context,
                      'Standard Record Actions',
                      'Using LightButton for consistent UI with the rest of the application.',
                      ActionsButton(
                        children: [
                          LightButton(
                            permission: null,
                            action: DataAction.edit,
                            title: 'Edit Record',
                            onPressed: () {},
                            expanded: true,
                          ),
                          LightButton(
                            permission: null,
                            action: DataAction.delete,
                            title: 'Remove Item',
                            onPressed: () {},
                            iconColor: Colors.red,
                            expanded: true,
                          ),
                        ],
                      ),
                    ),
                    _buildRow(
                      context,
                      'Mixed Content',
                      'Using LightButton with custom icons and titles.',
                      ActionsButton(
                        children: [
                          LightButton(
                            permission: null,
                            title: 'Download CSV',
                            iconOverride: Icons.file_download_outlined,
                            onPressed: () {},
                          ),
                          LightButton(
                            permission: null,
                            title: 'Print Label',
                            iconOverride: Icons.print_outlined,
                            onPressed: () {},
                          ),
                          LightButton(
                            permission: null,
                            title: 'Share via Email',
                            iconOverride: Icons.email_outlined,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    _buildRow(
                      context,
                      'Simple Action',
                      'Minimalist variant with a single LightButton.',
                      ActionsButton(
                        children: [
                          LightButton(
                            permission: null,
                            action: DataAction.confirm,
                            title: 'Sync Now',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    _buildRow(
                      context,
                      'Empty / Hidden',
                      'Verification of behavior when no actions are available.',
                      const ActionsButton(children: []),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

TableRow _buildHeaderRow(BuildContext context) {
  final theme = Theme.of(context);
  final headerStyle = theme.textTheme.titleSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
  );

  return TableRow(
    decoration: BoxDecoration(
      color: theme.brightness == Brightness.light
          ? Colors.grey.shade50
          : Colors.white.withOpacity(0.05),
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text('Scenario', style: headerStyle),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text('Preview', style: headerStyle),
      ),
    ],
  );
}

TableRow _buildRow(
    BuildContext context, String title, String description, Widget widget) {
  final theme = Theme.of(context);

  return TableRow(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withOpacity(0.05)),
      ),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: widget,
        ),
      ),
    ],
  );
}
