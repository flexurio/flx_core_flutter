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
      title: 'Date Range Picker Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Range Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropDownSmallDateRange(
          labelText: 'Select Date Range',
          onChanged: (range) {
            debugPrint('Start: ${range.startDate}, End: ${range.endDate}');
          },
          minDate: DateTime.now().subtract(const Duration(days: 365)),
          maxDate: DateTime.now().add(const Duration(days: 365)),
        ),
      ),
    );
  }
}
