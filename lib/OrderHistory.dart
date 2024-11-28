import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'databasehelper.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> orders = [];

  // Fetch orders based on date
  void fetchOrders() async {
    final date = dateController.text;
    if (date.isNotEmpty) {
      orders = await DatabaseHelper.instance.getOrdersForDate(date);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Enter Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: fetchOrders,
              child: Text("Fetch Orders"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(orders[index]['food_item']),
                    subtitle: Text("\$${orders[index]['cost']}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
