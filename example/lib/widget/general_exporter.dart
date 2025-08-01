import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeneralExporter Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeneralExporter Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _exportData(context);
          },
          child: const Text('Export Data'),
        ),
      ),
    );
  }

  void _exportData(BuildContext context) {
    final exporter = GeneralExporter<Product>(
      context: context,
      data: _products,
      title: 'Product List',
      headers: [
        PColumnHeader(title: 'Name'),
        PColumnHeader(title: 'Price'),
        PColumnHeader(title: 'Category'),
      ],
      body: [
        PColumnBody<Product>(contentBuilder: (product, index) => product.name),
        PColumnBody<Product>(
          numeric: true,
          contentBuilder: (product, index) => product.price.format(2),
        ),
        PColumnBody<Product>(
          contentBuilder: (product, index) => product.category,
        ),
      ],
      permissions: null,
      group1: (product) => product.category,
    );

    exporter.export();
  }
}

class Product {
  final String name;
  final double price;
  final String category;

  Product(this.name, this.price, this.category);
}

final List<Product> _products = [
  Product('Laptop', 1200.2, 'Electronics'),
  Product('Keyboard', 75.345, 'Electronics'),
  Product('Mouse', 25, 'Electronics'),
  Product('T-Shirt', 20.454, 'Apparel'),
  Product('Jeans', 50.4545, 'Apparel'),
  Product('Hat', 15, 'Apparel'),
];
