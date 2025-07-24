import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

void main() {
  flavorConfig = FlavorConfig(
    companyId: '02',
    companyName: 'PT. Tirta Lestari',
    companyPhone: '(031) 8787654',
    companyWebsite: 'www.tirtalestari.co.id',
    companyAddress: 'Jl. Raya Waru No.10, Sidoarjo, Jawa Timur 61256',
    apiUrl: 'https://erp-tirta-lestari-api-dev.flexurio.com',
    colorSoft: const Color(0XFF28B463).lighten(.3),
    color: const Color(0XFF28B463),
    backgroundLoginPage: 'asset/image/background-2.jpg',
    applicationConfig: null,
  );
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YuhuTable Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
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
      appBar: AppBar(title: const Text('YuhuTable with 7 Columns')),
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
