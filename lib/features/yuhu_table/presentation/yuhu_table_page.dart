import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class YuhuTablePage extends StatefulWidget {
  const YuhuTablePage({super.key});

  @override
  State<YuhuTablePage> createState() => _YuhuTablePageState();
}

class _YuhuTablePageState extends State<YuhuTablePage> {
  List<ProductDemo> products = [
    ProductDemo(
      name: 'Apple iPhone 14',
      category: 'Smartphone',
      brand: 'Apple',
      quantity: 15,
      price: 999.99,
      inStock: true,
      location: 'Warehouse A',
    ),
    ProductDemo(
      name: 'Galaxy S23',
      category: 'Smartphone',
      brand: 'Samsung',
      quantity: 25,
      price: 899.50,
      inStock: true,
      location: 'Warehouse B',
    ),
    ProductDemo(
      name: 'Xiaomi Mi 11',
      category: 'Smartphone',
      brand: 'Xiaomi',
      quantity: 5,
      price: 699,
      inStock: false,
      location: 'Warehouse C',
    ),
    ProductDemo(
      name: 'Dell XPS 13',
      category: 'Laptop',
      brand: 'Dell',
      quantity: 10,
      price: 1199.99,
      inStock: true,
      location: 'Warehouse A',
    ),
    ProductDemo(
      name: 'MacBook Pro',
      category: 'Laptop',
      brand: 'Apple',
      quantity: 7,
      price: 1899.99,
      inStock: false,
      location: 'Warehouse B',
    ),
    ProductDemo(
      name: 'Dell XPS 13',
      category: 'Laptop',
      brand: 'Dell',
      quantity: 10,
      price: 1199.99,
      inStock: true,
      location: 'Warehouse A',
    ),
    ProductDemo(
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
        child: YuhuTable<ProductDemo>(
          data: products,
          columns: [
            TableColumn<ProductDemo>(
              title: 'Name',
              width: 180,
              builder: (item, _) => Text(item.name),
              sortString: (item) => item.name,
            ),
            TableColumn<ProductDemo>(
              title: 'Category',
              width: 120,
              builder: (item, _) => Text(item.category),
              sortString: (item) => item.category,
            ),
            TableColumn<ProductDemo>(
              title: 'Brand',
              width: 120,
              builder: (item, _) => Text(item.brand),
              sortString: (item) => item.brand,
            ),
            TableColumn<ProductDemo>(
              title: 'Quantity',
              width: 100,
              alignment: Alignment.center,
              builder: (item, _) => Text('${item.quantity}'),
              sortNum: (item) => item.quantity,
            ),
            TableColumn<ProductDemo>(
              title: 'Price',
              width: 100,
              alignment: Alignment.centerRight,
              builder: (item, _) => Text('\$${item.price.toStringAsFixed(2)}'),
              sortNum: (item) => item.price,
            ),
            TableColumn<ProductDemo>(
              title: 'In Stock',
              width: 100,
              alignment: Alignment.center,
              builder: (item, _) => Icon(
                item.inStock ? Icons.check : Icons.close,
                color: item.inStock ? Colors.green : Colors.red,
              ),
              sortNum: (item) => item.inStock ? 1 : 0,
            ),
            TableColumn<ProductDemo>(
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
                case 1:
                  products.sort(
                    (a, b) => ascending
                        ? a.category.compareTo(b.category)
                        : b.category.compareTo(a.category),
                  );
                case 2:
                  products.sort(
                    (a, b) => ascending
                        ? a.brand.compareTo(b.brand)
                        : b.brand.compareTo(a.brand),
                  );
                case 3:
                  products.sort(
                    (a, b) => ascending
                        ? a.quantity.compareTo(b.quantity)
                        : b.quantity.compareTo(a.quantity),
                  );
                case 4:
                  products.sort(
                    (a, b) => ascending
                        ? a.price.compareTo(b.price)
                        : b.price.compareTo(a.price),
                  );
                case 5:
                  products.sort(
                    (a, b) => ascending
                        ? (a.inStock ? 1 : 0).compareTo(b.inStock ? 1 : 0)
                        : (b.inStock ? 1 : 0).compareTo(a.inStock ? 1 : 0),
                  );
                case 6:
                  products.sort(
                    (a, b) => ascending
                        ? a.location.compareTo(b.location)
                        : b.location.compareTo(a.location),
                  );
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

class ProductDemo {

  ProductDemo({
    required this.name,
    required this.category,
    required this.brand,
    required this.quantity,
    required this.price,
    required this.inStock,
    required this.location,
  });
  final String name;
  final String category;
  final String brand;
  final int quantity;
  final double price;
  final bool inStock;
  final String location;
}
