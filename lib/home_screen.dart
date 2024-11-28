import 'package:flutter/material.dart';
import 'create_order.dart';
import 'view_order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _targetCostController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Ordering App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a Target Cost per Day:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _targetCostController,
              decoration: const InputDecoration(
                hintText: 'Enter your target cost',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Pick a Date:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                hintText: 'Enter a date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_targetCostController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrderScreen(
                        targetCost: double.parse(_targetCostController.text),
                        date: _dateController.text,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill out both fields!'),
                  ));
                }
              },
              child: const Text('Create Order'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_dateController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewOrderScreen(
                        date: _dateController.text,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a date to view orders!'),
                  ));
                }
              },
              child: const Text('View Orders for a Date'),
            ),
          ],
        ),
      ),
    );
  }
}
