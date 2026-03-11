import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: DataTableBackend,
)
Widget dataTableBackendDefault(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableBackend<Map<String, dynamic>>(
        status: Status.loaded,
        pageOptions: PageOptions<Map<String, dynamic>>.empty(
          data: const [
            {'id': 1, 'name': 'Item A', 'value': 100},
            {'id': 2, 'name': 'Item B', 'value': 200},
          ],
        ),
        columns: [
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'ID',
              backendKeySort: 'id',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['id'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(label: 'Name', backendKeySort: 'name'),
            widthFlex: 2,
            body: (data) => DataCell(Text(data['name'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'Value',
              backendKeySort: 'value',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['value'].toString())),
          ),
        ],
        actionRight: (refreshButton) => [
          refreshButton,
          const SizedBox(width: 8),
          ElevatedButton(onPressed: () {}, child: const Text('Add')),
        ],
        onRefresh: () {},
        onChanged: (pageOptions) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Action Multiple',
  type: DataTableBackend,
)
Widget dataTableBackendWithActionMultiple(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableBackend<Map<String, dynamic>>(
        status: Status.loaded,
        actionMultiple: (selected) => Row(
          children: [
            Text('${selected.length} items selected'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Delete Selected'),
            ),
          ],
        ),
        pageOptions: PageOptions<Map<String, dynamic>>.empty(
          data: const [
            {'id': 1, 'name': 'Item A', 'value': 100},
            {'id': 2, 'name': 'Item B', 'value': 200},
          ],
        ),
        columns: [
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'ID',
              backendKeySort: 'id',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['id'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(label: 'Name', backendKeySort: 'name'),
            widthFlex: 2,
            body: (data) => DataCell(Text(data['name'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'Value',
              backendKeySort: 'value',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['value'].toString())),
          ),
        ],
        actionRight: (refreshButton) => [
          refreshButton,
        ],
        onRefresh: () {},
        onChanged: (pageOptions) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Pinned Columns',
  type: DataTableBackend,
)
Widget dataTableBackendWithPinnedColumns(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableBackend<Map<String, dynamic>>(
        status: Status.loaded,
        freezeFirstColumn: true,
        freezeLastColumn: true,
        pageOptions: PageOptions<Map<String, dynamic>>.empty(
          data: const [
            {'id': 1, 'name': 'Item A', 'desc': 'Description A', 'value': 100},
            {'id': 2, 'name': 'Item B', 'desc': 'Description B', 'value': 200},
            {'id': 3, 'name': 'Item C', 'desc': 'Description C', 'value': 300},
          ],
        ),
        columns: [
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'ID',
              backendKeySort: 'id',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['id'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(label: 'Name', backendKeySort: 'name'),
            widthFlex: 2,
            body: (data) => DataCell(Text(data['name'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(label: 'Description', backendKeySort: 'desc'),
            widthFlex: 3,
            body: (data) => DataCell(Text(data['desc'].toString())),
          ),
          DTColumn<Map<String, dynamic>>(
            head: const DTHead(
              label: 'Value',
              backendKeySort: 'value',
              numeric: true,
            ),
            widthFlex: 1,
            body: (data) => DataCell(Text(data['value'].toString())),
          ),
        ],
        actionRight: (refreshButton) => [
          refreshButton,
        ],
        onRefresh: () {},
        onChanged: (pageOptions) {},
      ),
    ),
  );
}
