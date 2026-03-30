import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Sales Order Detail',
  type: YuhuTable,
)
Widget yuhuTableSalesOrderDetailUseCase(BuildContext context) {
  return const _SalesOrderDetailTableExample();
}

class _SalesOrderDetail {
  _SalesOrderDetail({
    required this.productName,
    required this.unit,
    required this.batchNo,
    required this.expiredDate,
    required this.quantity,
    required this.discount,
    required this.price,
    required this.subtotal,
  });

  final String productName;
  final String unit;
  final String batchNo;
  final DateTime expiredDate;
  final double quantity;
  final String discount;
  final String price;
  final String subtotal;
}

class _SalesOrderDetailTableExample extends StatelessWidget {
  const _SalesOrderDetailTableExample();

  @override
  Widget build(BuildContext context) {
    final List<_SalesOrderDetail> data = [
      _SalesOrderDetail(
        productName: 'Amoxicillin 500mg',
        unit: 'STRIP',
        batchNo: 'BATCH-XXX-001',
        expiredDate:
            DateTime.now().add(const Duration(days: 300)), // near expiration
        quantity: 10,
        discount: '0%',
        price: 'Rp 150.000',
        subtotal: 'Rp 1.500.000',
      ),
      _SalesOrderDetail(
        productName: 'Paracetamol 500mg',
        unit: 'BOX',
        batchNo: 'BATCH-YYY-002',
        expiredDate: DateTime.now().add(const Duration(days: 500)),
        quantity: 5,
        discount: '5%',
        price: 'Rp 50.000',
        subtotal: 'Rp 237.500',
      ),
      _SalesOrderDetail(
        productName: 'Vitamin C 1000mg',
        unit: 'STRIP',
        batchNo: 'BATCH-ZZZ-003',
        expiredDate: DateTime.now().add(const Duration(days: 100)), // very near
        quantity: 20,
        discount: '10%',
        price: 'Rp 25.000',
        subtotal: 'Rp 450.000',
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: YuhuTable<_SalesOrderDetail>(
                width: 1800,
                data: data,
                columns: [
                  TableColumn(
                    width: 400,
                    flex:
                        1, // At least one column must have flex to prevent equal distribution
                    title: 'Product Name',
                    builder: (detail, _) => Text(detail.productName),
                  ),
                  TableColumn(
                    width: 80,
                    title: 'Unit',
                    builder: (detail, _) => Text(detail.unit),
                  ),
                  TableColumn(
                    width: 180,
                    title: 'Batch No',
                    builder: (detail, _) => Text(detail.batchNo),
                  ),
                  TableColumn(
                    width: 120,
                    title: 'Expired Date',
                    builder: (detail, _) {
                      final isNearExpiration = detail.expiredDate.isBefore(
                          DateTime.now().add(const Duration(days: 365)));
                      return Tooltip(
                        message: isNearExpiration ? 'Near Expiration' : '',
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(detail.expiredDate),
                          style: TextStyle(
                              color: isNearExpiration ? Colors.red : null),
                        ),
                      );
                    },
                  ),
                  TableColumn(
                    width: 100,
                    title: 'Quantity',
                    builder: (detail, _) => Text(detail.quantity.toString()),
                  ),
                  _amountColumn(
                    title: 'Discount',
                    width: 100,
                    valueBuilder: (detail) => detail.discount,
                  ),
                  _amountColumn(
                    title: 'Price',
                    width: 150,
                    valueBuilder: (detail) => detail.price,
                  ),
                  _amountColumn(
                    title: 'Subtotal',
                    width: 150,
                    valueBuilder: (detail) => detail.subtotal,
                  ),
                  TableColumn(
                    width: 170,
                    title: 'Actions',
                    alignment: Alignment.centerRight,
                    builder: (detail, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined),
                          color: Colors.blue,
                          tooltip: 'Edit Batch',
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          color: Colors.green,
                          tooltip: 'Edit Qty',
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_money_outlined),
                          color: Colors.orange,
                          tooltip: 'Edit Price',
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableColumn<_SalesOrderDetail> _amountColumn({
    required String title,
    required double width,
    required String Function(_SalesOrderDetail detail) valueBuilder,
  }) {
    return TableColumn(
      title: title,
      width: width,
      alignment: Alignment.centerRight,
      builder: (detail, _) => Text(valueBuilder(detail)),
    );
  }
}
