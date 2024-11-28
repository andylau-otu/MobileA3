import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'fooditem.dart';

class FoodOrder extends StatefulWidget {
  @override
  _FoodOrderingPageState createState() => _FoodOrderingPageState();
}

class _FoodOrderingPageState extends State<FoodOrder> {
  final List<FoodItem> foodItems = [
    FoodItem('Burger', 5.0),
    FoodItem('Pizza', 8.0),
    FoodItem('Pasta', 7.0),
    FoodItem('Salad', 4.0),
    FoodItem('Sandwich', 3.5),
    FoodItem('Sushi', 10.0),
    FoodItem('Tacos', 6.0),
    FoodItem('Ice Cream', 2.5),
    FoodItem('Fried Chicken', 6.5),
    FoodItem('Steak', 12.0),
    FoodItem('French Fries', 2.0),
    FoodItem('Wrap', 5.5),
    FoodItem('Noodles', 4.5),
    FoodItem('Spring Rolls', 3.0),
    FoodItem('Dumplings', 6.5),
    FoodItem('Curry', 9.0),
    FoodItem('Soup', 4.0),
    FoodItem('Hotdog', 3.5),
    FoodItem('Burrito', 7.5),
    FoodItem('Ceviche', 8.5),
  ];

  List<FoodItem> selectedItems = [];
  double targetCost = 20.0;
  TextEditingController dateController = TextEditingController();

  // Method to save the selected order into the database
  void saveOrder() async {
    if (dateController.text.isNotEmpty) {
      for (var item in selectedItems) {
        await DatabaseHelper.instance.insertOrder({
          'date': dateController.text,
          'food_item': item.name,
          'cost': item.cost,
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order saved successfully!'),
      ));
    }
  }

  // Method to fetch orders for a date
  Future<List<Map<String, dynamic>>> getOrdersForDate(String date) async {
    return await DatabaseHelper.instance.getOrdersForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Ordering App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date input field
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Food item selection with target cost per day
            Text("Target Cost: \$${targetCost.toStringAsFixed(2)}"),
            Slider(
              value: targetCost,
              min: 5.0,
              max: 50.0,
              divisions: 9,
              label: targetCost.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  targetCost = value;
                });
              },
            ),
            SizedBox(height: 16),

            // List of food items to select from
            Text("Select Food Items:"),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(foodItems[index].name),
                    subtitle: Text("\$${foodItems[index].cost}"),
                    value: selectedItems.contains(foodItems[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null && value) {
                          selectedItems.add(foodItems[index]);
                        } else {
                          selectedItems.remove(foodItems[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Save button
            ElevatedButton(
              onPressed: saveOrder,
              child: Text("Save Order"),
            ),
          ],
        ),
      ),
    );
  }
}