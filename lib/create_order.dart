import 'package:flutter/material.dart';
import 'databasehelper.dart';

class CreateOrderScreen extends StatefulWidget {
  final double targetCost;
  final String date;

  const CreateOrderScreen({Key? key, required this.targetCost, required this.date}) : super(key: key);

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final List<Map<String, dynamic>> foodItems = [
    {'name': 'Pizza', 'cost': 8.99},
    {'name': 'Burger', 'cost': 5.99},
    {'name': 'Pasta', 'cost': 6.99},
    {'name': 'Salad', 'cost': 4.99},
    {'name': 'Sandwich', 'cost': 3.5},
    {'name': 'Sushi', 'cost': 10.0},
    {'name': 'Tacos', 'cost': 6.0},
    {'name': 'Ice Cream', 'cost': 2.5},
    {'name': 'Fried Chicken', 'cost': 6.5},
    {'name': 'Steak', 'cost': 12.0},
    {'name': 'French Fries', 'cost': 2.0},
    {'name': 'Wrap', 'cost': 5.5},
    {'name': 'Noodles', 'cost': 4.5},
    {'name': 'Spring Rolls', 'cost': 3.0},
    {'name': 'Dumplings', 'cost': 6.5},
    {'name': 'Curry', 'cost': 9.0},
    {'name': 'Soup', 'cost': 4.0},
    {'name': 'Hotdog', 'cost': 3.5},
    {'name': 'Burrito', 'cost': 7.5},
    {'name': 'Ceviche', 'cost': 8.5},
    // Add more items as needed
  ];

  List<Map<String, dynamic>> selectedItems = [];
  double totalCost = 0.0;

  void toggleSelection(Map<String, dynamic> item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
        totalCost -= item['cost'];
      } else if (totalCost + item['cost'] <= widget.targetCost) {
        selectedItems.add(item);
        totalCost += item['cost'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Exceeds target cost!'),
        ));
      }
    });
  }

  void saveOrder() async {
    for (var item in selectedItems) {
      await DatabaseHelper.instance.insertOrder({
        'date': widget.date,
        'food_item': item['name'],
        'cost': item['cost'],
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Order saved successfully!'),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final item = foodItems[index];
                final isSelected = selectedItems.contains(item);
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("\$${item['cost']}"),
                  trailing: Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isSelected ? Colors.green : null,
                  ),
                  onTap: () => toggleSelection(item),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Cost: \$${totalCost.toStringAsFixed(2)} / \$${widget.targetCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: saveOrder,
            child: const Text('Save Order'),
          ),
        ],
      ),
    );
  }
}
