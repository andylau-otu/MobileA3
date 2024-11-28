import 'package:hive/hive.dart';
import 'fooditem.dart';

part 'order_plan.g.dart'; // Generated file for Hive adapters

@HiveType(typeId: 1)
class OrderPlan {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final List<FoodItem> selectedItems;

  @HiveField(2)
  final double targetCost;

  OrderPlan(this.date, this.selectedItems, this.targetCost);
}