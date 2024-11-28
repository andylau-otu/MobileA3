// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderPlanAdapter extends TypeAdapter<OrderPlan> {
  @override
  final int typeId = 1;

  @override
  OrderPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderPlan(
      fields[0] as String,
      (fields[1] as List).cast<FoodItem>(),
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderPlan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.selectedItems)
      ..writeByte(2)
      ..write(obj.targetCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
