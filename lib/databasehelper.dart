import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor to initialize the database
  DatabaseHelper._init();

  // Lazy database initialization: if the database is null, create it
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('food_ordering.db');
    return _database!;
  }

  // Initialize the database and create the table
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);

    // Open the database (or create it if it doesn't exist)
    return await openDatabase(dbLocation, version: 1, onCreate: _onCreate);
  }

  // Create the table if it doesn't exist
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE food_orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      food_item TEXT,
      cost REAL
    )
    ''');
  }

  // Insert a new food order into the database
  Future<int> insertOrder(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('food_orders', row);
  }

  // Get orders for a specific date
  Future<List<Map<String, dynamic>>> getOrdersForDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'food_orders',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // Delete a food order by ID
  Future<int> deleteOrder(int id) async {
    final db = await instance.database;
    return await db.delete(
      'food_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update an existing food order by ID
  Future<int> updateOrder(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'food_orders',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
