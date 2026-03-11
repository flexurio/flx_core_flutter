import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: YuhuTable)
Widget yuhuTableUseCase(BuildContext context) {
  return const YuhuTableExample();
}

@UseCase(name: 'Many Columns', type: YuhuTable)
Widget yuhuTableManyColumnsUseCase(BuildContext context) {
  return const YuhuTableManyColumnsExample();
}

class Product {
  final String name;
  final String category;
  final String brand;
  final int quantity;
  final double price;
  final bool inStock;
  final String location;

  Product({
    required this.name,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.inStock,
    required this.location,
  });
}

class YuhuTableExample extends StatefulWidget {
  const YuhuTableExample({super.key});

  @override
  State<YuhuTableExample> createState() => _YuhuTableExampleState();
}

class _YuhuTableExampleState extends State<YuhuTableExample> {
  List<Product> products = [
    Product(
      name: 'Apple iPhone 14',
      category: 'Smartphone',
      brand: 'Apple',
      quantity: 15,
      price: 999.99,
      inStock: true,
      location: 'Warehouse A',
    ),
    Product(
      name: 'Galaxy S23',
      category: 'Smartphone',
      brand: 'Samsung',
      quantity: 25,
      price: 899.50,
      inStock: true,
      location: 'Warehouse B',
    ),
    Product(
      name: 'Xiaomi Mi 11',
      category: 'Smartphone',
      brand: 'Xiaomi',
      quantity: 5,
      price: 699.00,
      inStock: false,
      location: 'Warehouse C',
    ),
    Product(
      name: 'Dell XPS 13',
      category: 'Laptop',
      brand: 'Dell',
      quantity: 10,
      price: 1199.99,
      inStock: true,
      location: 'Warehouse A',
    ),
    Product(
      name: 'MacBook Pro',
      category: 'Laptop',
      brand: 'Apple',
      quantity: 7,
      price: 1899.99,
      inStock: false,
      location: 'Warehouse B',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YuhuTable Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: YuhuTable<Product>(
          data: products,
          columns: [
            TableColumn<Product>(
              title: 'Name',
              width: 180,
              builder: (item, _) => Text(item.name),
              sortString: (item) => item.name,
            ),
            TableColumn<Product>(
              title: 'Category',
              width: 120,
              builder: (item, _) => Text(item.category),
              sortString: (item) => item.category,
            ),
            TableColumn<Product>(
              title: 'Brand',
              width: 120,
              builder: (item, _) => Text(item.brand),
              sortString: (item) => item.brand,
            ),
            TableColumn<Product>(
              title: 'Quantity',
              width: 100,
              alignment: Alignment.center,
              builder: (item, _) => Text('${item.quantity}'),
              sortNum: (item) => item.quantity,
            ),
            TableColumn<Product>(
              title: 'Price',
              width: 100,
              alignment: Alignment.centerRight,
              builder: (item, _) => Text('\$${item.price.toStringAsFixed(2)}'),
              sortNum: (item) => item.price,
            ),
            TableColumn<Product>(
              title: 'In Stock',
              width: 100,
              alignment: Alignment.center,
              builder: (item, _) => Icon(
                item.inStock ? Icons.check : Icons.close,
                color: item.inStock ? Colors.green : Colors.red,
              ),
              sortNum: (item) => item.inStock ? 1 : 0,
            ),
            TableColumn<Product>(
              title: 'Location',
              width: 120,
              builder: (item, _) => Text(item.location),
              sortString: (item) => item.location,
            ),
          ],
          onSort: (index, ascending) {
            setState(() {
              switch (index) {
                case 0:
                  products.sort(
                    (a, b) => ascending
                        ? a.name.compareTo(b.name)
                        : b.name.compareTo(a.name),
                  );
                  break;
                case 1:
                  products.sort(
                    (a, b) => ascending
                        ? a.category.compareTo(b.category)
                        : b.category.compareTo(a.category),
                  );
                  break;
                case 2:
                  products.sort(
                    (a, b) => ascending
                        ? a.brand.compareTo(b.brand)
                        : b.brand.compareTo(a.brand),
                  );
                  break;
                case 3:
                  products.sort(
                    (a, b) => ascending
                        ? a.quantity.compareTo(b.quantity)
                        : b.quantity.compareTo(a.quantity),
                  );
                  break;
                case 4:
                  products.sort(
                    (a, b) => ascending
                        ? a.price.compareTo(b.price)
                        : b.price.compareTo(a.price),
                  );
                  break;
                case 5:
                  products.sort(
                    (a, b) => ascending
                        ? (a.inStock ? 1 : 0).compareTo(b.inStock ? 1 : 0)
                        : (b.inStock ? 1 : 0).compareTo(a.inStock ? 1 : 0),
                  );
                  break;
                case 6:
                  products.sort(
                    (a, b) => ascending
                        ? a.location.compareTo(b.location)
                        : b.location.compareTo(a.location),
                  );
                  break;
              }
            });
          },
          freezeFirstColumn: true,
          freezeLastColumn: true,
          rowsPerPage: 6,
          bodyHeight: 360,
        ),
      ),
    );
  }
}

class YuhuTableManyColumnsExample extends StatelessWidget {
  const YuhuTableManyColumnsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final data = List.generate(
      20,
      (index) => {
        'id': 'ID-$index',
        'name': 'Item Name $index',
        'col1': 'Data 1-$index',
        'col2': 'Data 2-$index',
        'col3': 'Data 3-$index',
        'col4': 'Data 4-$index',
        'col5': 'Data 5-$index',
        'col6': 'Data 6-$index',
        'col7': 'Data 7-$index',
        'col8': 'Data 8-$index',
        'col9': 'Data 9-$index',
        'status': index % 2 == 0 ? 'Active' : 'Inactive',
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Many Columns Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: YuhuTable<Map<String, String>>(
          data: data,
          freezeFirstColumn: true,
          freezeLastColumn: true,
          rowsPerPage: 10,
          bodyHeight: 500,
          columns: [
            TableColumn(
              title: 'ID',
              width: 80,
              builder: (item, _) => Text(item['id']!),
            ),
            TableColumn(
              title: 'Name',
              width: 150,
              builder: (item, _) => Text(item['name']!),
            ),
            ...List.generate(
              9,
              (index) => TableColumn<Map<String, String>>(
                title: 'Column ${index + 1}',
                width: 120,
                builder: (item, _) => Text(item['col${index + 1}']!),
              ),
            ),
            TableColumn(
              title: 'Status',
              width: 100,
              alignment: Alignment.center,
              builder: (item, _) => Chip(
                label: Text(
                  item['status']!,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: item['status'] == 'Active'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
