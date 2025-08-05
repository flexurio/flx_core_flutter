import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FDropDownSearchSmall Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SamplePage(),
    );
  }
}

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  String? selectedItem;

  final List<String> cities = [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Medan',
    'Makassar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dropdown Search Sample')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FDropDownSearchSmall<String>(
            labelText: "City",
            items: cities,
            initialValue: selectedItem,
            itemAsString: (item) => item,
            iconField: Icons.location_city,
            showClearButton: true,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
              });
              debugPrint("Selected: $value");
            },
          ),
        ),
      ),
    );
  }
}
