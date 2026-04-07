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

@widgetbook.UseCase(
  name: 'Voucher Payment List',
  type: DataTableBackend,
)
Widget dataTableBackendVoucherPayment(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableBackend<_FakePayment>(
        status: Status.loaded,
        pageOptions: PageOptions<_FakePayment>.empty(
          data: [
            _FakePayment(
              transactionNo: 'TRX001',
              transactionDate: DateTime.now(),
              supplierName: 'Supplier A',
              orderId: 'ORD-123',
              registerId: 'REG-01',
              realizationNo: 'REAL-01',
              total: 1500000,
              invoiceNo: 'INV-001',
              receiptNo: 'RCP-001',
              paymentId: 'PAY-001',
              paymentDate: DateTime.now(),
              paymentTotal: 1500000,
              paymentRemaining: 0,
              period: '2024-03',
            ),
            _FakePayment(
              transactionNo: 'TRX002',
              transactionDate: DateTime.now(),
              supplierName: 'Supplier B',
              orderId: 'ORD-124',
              registerId: 'REG-02',
              realizationNo: null,
              total: 2000000,
              invoiceNo: null,
              receiptNo: null,
              paymentId: null,
              paymentDate: null,
              paymentTotal: 0,
              paymentRemaining: 2000000,
              period: '2024-03',
            ),
          ],
        ),
        columns: [
          DTColumn<_FakePayment>(
            widthFlex: 8,
            head: const DTHead(
              backendKeySort: 'transaction_no',
              label: 'Transaction No',
            ),
            body: (payment) => DataCell(Text(payment.transactionNo).canCopy()),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Transaction Date',
              backendKeySort: 'transaction_date',
            ),
            body: (payment) => DataCell(Text(payment.transactionDate.yMMMd)),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Supplier',
              backendKeySort: 'supplier',
            ),
            body: (payment) => DataCell(Text(payment.supplierName)),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Order ID',
              backendKeySort: 'order_id',
            ),
            body: (payment) => DataCell(Text(payment.orderId).canCopy()),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Register ID',
              backendKeySort: 'register_id',
            ),
            body: (payment) =>
                DataCell(Text(payment.registerId ?? '').canCopy()),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Realization No',
              backendKeySort: 'realization_no',
            ),
            body: (payment) => DataCell(Text(payment.realizationNo ?? '')),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Total',
              backendKeySort: 'total',
            ),
            body: (payment) => DataCell(Text(payment.total.format())),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Invoice No',
              backendKeySort: 'invoice_no',
            ),
            body: (payment) =>
                DataCell(Text(payment.invoiceNo ?? '-').canCopy()),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Receipt No',
              backendKeySort: 'receipt_no',
            ),
            body: (payment) => DataCell(Text(payment.receiptNo ?? '')),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 6,
            head: const DTHead(
              label: 'Payment No',
              backendKeySort: 'payment_id',
            ),
            body: (payment) =>
                DataCell(Text(payment.paymentId ?? '-').canCopy()),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Payment Date',
              backendKeySort: 'payment_date',
            ),
            body: (payment) =>
                DataCell(Text(payment.paymentDate?.yMMMd ?? '-')),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Payment Total',
              backendKeySort: 'payment_total',
            ),
            body: (payment) => DataCell(Text(payment.paymentTotal.format())),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 5,
            head: const DTHead(
              label: 'Payment Remaining',
              backendKeySort: 'payment_remaining',
            ),
            body: (payment) =>
                DataCell(Text(payment.paymentRemaining.format())),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 4,
            head: const DTHead(
              label: 'Period',
              backendKeySort: 'period',
            ),
            body: (payment) => DataCell(Text(payment.period)),
          ),
          DTColumn<_FakePayment>(
            widthFlex: 10,
            head: const DTHead(
              label: 'Actions',
              backendKeySort: null,
            ),
            body: (payment) => DataCell(
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      tooltip: 'View Voucher'),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.book_outlined),
                      tooltip: 'View Journal'),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.payment_outlined),
                      tooltip: 'View Payment'),
                  if (payment.paymentId == null)
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_card_outlined),
                        tooltip: 'Create Payment'),
                ],
              ),
            ),
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
  name: 'Product Return Check',
  type: DataTableBackend,
)
Widget dataTableBackendProductReturnCheck(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DataTableBackend<_FakeProductReturnCheck>(
        freezeFirstColumn: true,
        freezeLastColumn: true,
        status: Status.loaded,
        onChanged: (pageOptions) {},
        onRefresh: () {},
        actionRight: (refreshButton) => [
          refreshButton,
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create Check'),
          ),
        ],
        pageOptions: PageOptions<_FakeProductReturnCheck>.empty(
          data: [
            _FakeProductReturnCheck(
              id: 'PRC-001',
              referenceNo: 'REF-2024-001',
              status: const _FakeColorType('Pending', Colors.orange),
              qaStatus: const _FakeColorType('Checking', Colors.blue),
              productId: 'PROD-01',
              productName: 'Amoxicillin 500mg',
              batchNo: 'BATCH-X1',
              quantity: 100,
              unit: 'Box',
              qaCheckedAt: DateTime.now(),
              deliveryOrderId: 'DO-001',
            ),
            _FakeProductReturnCheck(
              id: 'PRC-002',
              referenceNo: 'REF-2024-002',
              status: const _FakeColorType('Completed', Colors.green),
              qaStatus: const _FakeColorType('Released', Colors.teal),
              productId: 'PROD-02',
              productName: 'Paracetamol 500mg',
              batchNo: 'BATCH-Y2',
              quantity: 50,
              unit: 'Strip',
              qaCheckedAt: DateTime.now(),
              deliveryOrderId: 'DO-002',
            ),
          ],
        ),
        columns: [
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Product Return ID',
              backendKeySort: 'product_return_id.id',
            ),
            body: (item) => DataCell(Text(item.id).canCopy()),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Reference No',
              backendKeySort: 'product_return_id.reference_no',
            ),
            body: (item) => DataCell(Text(item.referenceNo)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Status',
              backendKeySort: null,
            ),
            body: (item) => DataCell(ChipType(item.status)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'QA Check Status',
              backendKeySort: null,
            ),
            body: (item) => DataCell(ChipType(item.qaStatus)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Product ID',
              backendKeySort: 'product_id.id',
            ),
            body: (item) => DataCell(Text(item.productId)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Product Name',
              backendKeySort: 'product_id.name',
            ),
            body: (item) => DataCell(Text(item.productName)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Batch No',
              backendKeySort: 'batch.id',
            ),
            body: (item) => DataCell(Text(item.batchNo)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 3,
            head: const DTHead(
              numeric: true,
              label: 'Quantity',
              backendKeySort: 'quantity',
            ),
            body: (item) => DataCell(Text(item.quantity.toString())),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 3,
            head: const DTHead(
              label: 'Unit',
              backendKeySort: 'unit_id.id',
            ),
            body: (item) => DataCell(Text(item.unit)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 10,
            head: const DTHead(
              numeric: true,
              label: 'QA Checked At',
              backendKeySort: 'quality_assurance_check_date',
            ),
            body: (item) => DataCell(Text(item.qaCheckedAt.yMMMdHm)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Delivery Order ID',
              backendKeySort: 'delivery_order.id',
            ),
            body: (item) => DataCell(Text(item.deliveryOrderId)),
          ),
          DTColumn<_FakeProductReturnCheck>(
            widthFlex: 8,
            head: const DTHead(
              label: 'Action',
              backendKeySort: null,
            ),
            body: (item) => DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FakePayment {
  _FakePayment({
    required this.transactionNo,
    required this.transactionDate,
    required this.supplierName,
    required this.orderId,
    required this.registerId,
    required this.realizationNo,
    required this.total,
    required this.invoiceNo,
    required this.receiptNo,
    required this.paymentId,
    required this.paymentDate,
    required this.paymentTotal,
    required this.paymentRemaining,
    required this.period,
  });

  final String transactionNo;
  final DateTime transactionDate;
  final String supplierName;
  final String orderId;
  final String? registerId;
  final String? realizationNo;
  final double total;
  final String? invoiceNo;
  final String? receiptNo;
  final String? paymentId;
  final DateTime? paymentDate;
  final double paymentTotal;
  final double paymentRemaining;
  final String period;
}

class _FakeProductReturnCheck {
  _FakeProductReturnCheck({
    required this.id,
    required this.referenceNo,
    required this.status,
    required this.qaStatus,
    required this.productId,
    required this.productName,
    required this.batchNo,
    required this.quantity,
    required this.unit,
    required this.qaCheckedAt,
    required this.deliveryOrderId,
  });

  final String id;
  final String referenceNo;
  final ColorType status;
  final ColorType qaStatus;
  final String productId;
  final String productName;
  final String batchNo;
  final double quantity;
  final String unit;
  final DateTime qaCheckedAt;
  final String deliveryOrderId;
}

class _FakeColorType implements ColorType {
  const _FakeColorType(this.label, this.color);
  @override
  final String label;
  @override
  final Color color;
}
