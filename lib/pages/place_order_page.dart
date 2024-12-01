
import 'package:flutter/material.dart';
import '../components/order_item.dart';
import '../models/food_item.dart';
import '../models/order.dart';
import '../database/database_helper.dart';
import 'placed_orders_page.dart';

class OrderScreen extends StatefulWidget {

  final double budget;
  final DateTime orderDate;

  const OrderScreen({super.key, required this.budget,required this.orderDate});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<FoodItem, int> foodList = {};
  List<FoodItem> foodItems = [];
  Map<FoodItem, int> currentOrder = {};
  DateTime placedOrderDate = DateTime.now();
  late double remainingBudget;
  final DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    remainingBudget = widget.budget;
    placedOrderDate = widget.orderDate;
    loadFoodItems();
  }

  void loadFoodItems() async {
    final items = await db.loadFoodItems();
    setState(() {
      foodItems = items;
    });
    
    for (var food in foodItems){
      setState(() {
        foodList[food] = (foodList[food] ?? 0);
      });
    }
  }

  double getTotalCost() {
    return foodList.entries
        .fold(0, (sum, entry) => sum + (entry.key.cost * entry.value));
  }

  Future<void> placeOrder() async {
    final totalCost = getTotalCost();
    final orderItems = currentOrder.entries
        .map((entry) => {
      'foodItem': entry.key,
      'quantity': entry.value,
    })
        .toList();

    final order = Order(
      date: placedOrderDate,
      items: orderItems,
      totalCost: totalCost,
    );

    final existingOrders = await db.loadOrders();
    existingOrders.add(order);
    await db.saveOrders(existingOrders);

    setState(() {
      foodList.clear();
      remainingBudget = widget.budget;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Order placed on ${order.date.toLocal()}! Total: \$${totalCost.toStringAsFixed(2)}'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PlacedOrdersScreen()),
    );
  }

  void updateQuantity(FoodItem item, int x) {
    setState(() {
      final newQuantity = (foodList[item] ?? 0) + x;
      foodList[item] = newQuantity;
      remainingBudget -= item.cost * x;
      currentOrder[item] = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {'foodList': foodList, 'budget': remainingBudget});
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final entry = foodList.entries.elementAt(index);
                final item = entry.key;
                final quantity = entry.value;

                return OrderItem(
                  item: item,
                  quantity: quantity,
                  remainingBudget: remainingBudget,
                  onAdd: () => updateQuantity(item, 1),
                  onRemove: () => updateQuantity(item, -1),

                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${getTotalCost().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: foodList.isNotEmpty ? placeOrder : null,
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}