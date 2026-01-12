import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/check_in.dart';
import '../models/task.dart';
import '../models/sales_target.dart';

class StorageService {
  static const String customersBox = 'customers';
  static const String productsBox = 'products';
  static const String ordersBox = 'orders';
  static const String checkInsBox = 'checkIns';
  static const String tasksBox = 'tasks';
  static const String targetsBox = 'targets';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Open boxes without type adapters - we'll use JSON storage
    await Hive.openBox<Map>(customersBox);
    await Hive.openBox<Map>(productsBox);
    await Hive.openBox<Map>(ordersBox);
    await Hive.openBox<Map>(checkInsBox);
    await Hive.openBox<Map>(tasksBox);
    await Hive.openBox<Map>(targetsBox);
  }

  // Customer operations
  static Future<void> saveCustomer(Customer customer) async {
    final box = Hive.box<Map>(customersBox);
    await box.put(customer.id, customer.toJson());
  }

  static Future<List<Customer>> getCustomers() async {
    final box = Hive.box<Map>(customersBox);
    return box.values
        .map((json) => Customer.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<Customer?> getCustomer(String id) async {
    final box = Hive.box<Map>(customersBox);
    final json = box.get(id);
    return json != null ? Customer.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  static Future<void> deleteCustomer(String id) async {
    final box = Hive.box<Map>(customersBox);
    await box.delete(id);
  }

  // Product operations
  static Future<void> saveProduct(Product product) async {
    final box = Hive.box<Map>(productsBox);
    await box.put(product.id, product.toJson());
  }

  static Future<List<Product>> getProducts() async {
    final box = Hive.box<Map>(productsBox);
    return box.values
        .map((json) => Product.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<Product?> getProduct(String id) async {
    final box = Hive.box<Map>(productsBox);
    final json = box.get(id);
    return json != null ? Product.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  // Order operations
  static Future<void> saveOrder(Order order) async {
    final box = Hive.box<Map>(ordersBox);
    await box.put(order.id, order.toJson());
  }

  static Future<List<Order>> getOrders() async {
    final box = Hive.box<Map>(ordersBox);
    return box.values
        .map((json) => Order.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<Order?> getOrder(String id) async {
    final box = Hive.box<Map>(ordersBox);
    final json = box.get(id);
    return json != null ? Order.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  // Check-in operations
  static Future<void> saveCheckIn(CheckIn checkIn) async {
    final box = Hive.box<Map>(checkInsBox);
    await box.put(checkIn.id, checkIn.toJson());
  }

  static Future<List<CheckIn>> getCheckIns() async {
    final box = Hive.box<Map>(checkInsBox);
    return box.values
        .map((json) => CheckIn.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<CheckIn?> getCheckIn(String id) async {
    final box = Hive.box<Map>(checkInsBox);
    final json = box.get(id);
    return json != null ? CheckIn.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  // Task operations
  static Future<void> saveTask(Task task) async {
    final box = Hive.box<Map>(tasksBox);
    await box.put(task.id, task.toJson());
  }

  static Future<List<Task>> getTasks() async {
    final box = Hive.box<Map>(tasksBox);
    return box.values
        .map((json) => Task.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<Task?> getTask(String id) async {
    final box = Hive.box<Map>(tasksBox);
    final json = box.get(id);
    return json != null ? Task.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  static Future<void> deleteTask(String id) async {
    final box = Hive.box<Map>(tasksBox);
    await box.delete(id);
  }

  // Sales Target operations
  static Future<void> saveSalesTarget(SalesTarget target) async {
    final box = Hive.box<Map>(targetsBox);
    await box.put(target.id, target.toJson());
  }

  static Future<List<SalesTarget>> getSalesTargets() async {
    final box = Hive.box<Map>(targetsBox);
    return box.values
        .map((json) => SalesTarget.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<SalesTarget?> getSalesTarget(String id) async {
    final box = Hive.box<Map>(targetsBox);
    final json = box.get(id);
    return json != null ? SalesTarget.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  // SharedPreferences for simple key-value storage
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }
}
