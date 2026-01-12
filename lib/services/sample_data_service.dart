import 'package:uuid/uuid.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/sales_target.dart';
import '../models/task.dart';
import 'storage_service.dart';

class SampleDataService {
  static const uuid = Uuid();

  static Future<void> initializeSampleData() async {
    // Check if data already exists
    final customers = await StorageService.getCustomers();
    if (customers.isNotEmpty) {
      return; // Data already initialized
    }

    // Initialize customers
    await _initializeCustomers();
    
    // Initialize products
    await _initializeProducts();
    
    // Initialize sample orders
    await _initializeSampleOrders();
    
    // Initialize sales targets
    await _initializeSalesTargets();
    
    // Initialize tasks
    await _initializeTasks();
  }

  static Future<void> _initializeCustomers() async {
    final customers = [
      Customer(
        id: uuid.v4(),
        name: 'Tech Solutions Ltd',
        email: 'contact@techsolutions.com',
        phone: '+1 (555) 123-4567',
        address: '123 Business Park, Suite 100',
        city: 'New York',
        latitude: 40.7128,
        longitude: -74.0060,
        customerType: 'Wholesale',
        creditLimit: 50000.0,
        outstandingBalance: 12500.0,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'Regular customer, prefers monthly payment',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
      Customer(
        id: uuid.v4(),
        name: 'Global Retail Chain',
        email: 'orders@globalretail.com',
        phone: '+1 (555) 234-5678',
        address: '456 Commerce Street',
        city: 'Los Angeles',
        latitude: 34.0522,
        longitude: -118.2437,
        customerType: 'Retail',
        creditLimit: 30000.0,
        outstandingBalance: 8500.0,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 7)),
        notes: 'Large volume orders, seasonal buyer',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      Customer(
        id: uuid.v4(),
        name: 'City Distributors Inc',
        email: 'info@citydistributors.com',
        phone: '+1 (555) 345-6789',
        address: '789 Industrial Ave',
        city: 'Chicago',
        latitude: 41.8781,
        longitude: -87.6298,
        customerType: 'Distributor',
        creditLimit: 75000.0,
        outstandingBalance: 25000.0,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'VIP customer, expedited shipping required',
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
      ),
      Customer(
        id: uuid.v4(),
        name: 'Premium Store Co',
        email: 'sales@premiumstore.com',
        phone: '+1 (555) 456-7890',
        address: '321 Main Street',
        city: 'San Francisco',
        latitude: 37.7749,
        longitude: -122.4194,
        customerType: 'Retail',
        creditLimit: 40000.0,
        outstandingBalance: 5000.0,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 14)),
        notes: 'High-end products preferred',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      Customer(
        id: uuid.v4(),
        name: 'Metro Wholesale Hub',
        email: 'orders@metrowholesale.com',
        phone: '+1 (555) 567-8901',
        address: '654 Market Plaza',
        city: 'Boston',
        latitude: 42.3601,
        longitude: -71.0589,
        customerType: 'Wholesale',
        creditLimit: 60000.0,
        outstandingBalance: 18000.0,
        lastVisitDate: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Weekly delivery schedule',
        createdAt: DateTime.now().subtract(const Duration(days: 450)),
      ),
    ];

    for (var customer in customers) {
      await StorageService.saveCustomer(customer);
    }
  }

  static Future<void> _initializeProducts() async {
    final products = [
      Product(
        id: uuid.v4(),
        name: 'Premium Laptop Pro 15"',
        description: 'High-performance laptop with 16GB RAM and 512GB SSD',
        category: 'Electronics',
        sku: 'ELEC-LAP-001',
        barcode: '1234567890123',
        price: 1299.99,
        costPrice: 900.00,
        stockQuantity: 45,
        unit: 'Piece',
        discount: 10.0,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      Product(
        id: uuid.v4(),
        name: 'Wireless Mouse Ultra',
        description: 'Ergonomic wireless mouse with precision tracking',
        category: 'Electronics',
        sku: 'ELEC-MOU-002',
        barcode: '1234567890124',
        price: 49.99,
        costPrice: 25.00,
        stockQuantity: 200,
        unit: 'Piece',
        discount: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      Product(
        id: uuid.v4(),
        name: 'Office Chair Deluxe',
        description: 'Comfortable ergonomic office chair with lumbar support',
        category: 'Furniture',
        sku: 'FURN-CHA-003',
        barcode: '1234567890125',
        price: 299.99,
        costPrice: 180.00,
        stockQuantity: 75,
        unit: 'Piece',
        discount: 15.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Product(
        id: uuid.v4(),
        name: 'Standing Desk Pro',
        description: 'Adjustable height standing desk for modern offices',
        category: 'Furniture',
        sku: 'FURN-DSK-004',
        barcode: '1234567890126',
        price: 599.99,
        costPrice: 350.00,
        stockQuantity: 35,
        unit: 'Piece',
        discount: 20.0,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Product(
        id: uuid.v4(),
        name: 'LED Monitor 27"',
        description: '4K Ultra HD monitor with HDR support',
        category: 'Electronics',
        sku: 'ELEC-MON-005',
        barcode: '1234567890127',
        price: 449.99,
        costPrice: 280.00,
        stockQuantity: 60,
        unit: 'Piece',
        discount: 0.0,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Product(
        id: uuid.v4(),
        name: 'Keyboard Mechanical RGB',
        description: 'Mechanical gaming keyboard with RGB backlighting',
        category: 'Electronics',
        sku: 'ELEC-KEY-006',
        barcode: '1234567890128',
        price: 129.99,
        costPrice: 70.00,
        stockQuantity: 120,
        unit: 'Piece',
        discount: 8.0,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: uuid.v4(),
        name: 'USB-C Hub 7-Port',
        description: 'Multi-port USB-C hub with HDMI and Ethernet',
        category: 'Electronics',
        sku: 'ELEC-HUB-007',
        barcode: '1234567890129',
        price: 79.99,
        costPrice: 40.00,
        stockQuantity: 150,
        unit: 'Piece',
        discount: 0.0,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Product(
        id: uuid.v4(),
        name: 'Desk Lamp LED',
        description: 'Adjustable LED desk lamp with touch control',
        category: 'Office Supplies',
        sku: 'OFFC-LAM-008',
        barcode: '1234567890130',
        price: 39.99,
        costPrice: 20.00,
        stockQuantity: 180,
        unit: 'Piece',
        discount: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    for (var product in products) {
      await StorageService.saveProduct(product);
    }
  }

  static Future<void> _initializeSampleOrders() async {
    final customers = await StorageService.getCustomers();
    final products = await StorageService.getProducts();

    if (customers.isEmpty || products.isEmpty) return;

    final orders = [
      Order(
        id: uuid.v4(),
        customerId: customers[0].id,
        customerName: customers[0].name,
        items: [
          OrderItem(
            productId: products[0].id,
            productName: products[0].name,
            quantity: 5,
            unitPrice: products[0].price,
            discount: 50.0,
            total: (products[0].price * 5) - 50.0,
          ),
          OrderItem(
            productId: products[1].id,
            productName: products[1].name,
            quantity: 10,
            unitPrice: products[1].price,
            discount: 0.0,
            total: products[1].price * 10,
          ),
        ],
        subtotal: 7000.0,
        discount: 50.0,
        tax: 595.0,
        total: 7545.0,
        status: 'Confirmed',
        paymentStatus: 'Partial',
        paymentMethod: 'Credit',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Urgent delivery required',
        salesRepId: 'REP001',
        isSynced: true,
      ),
      Order(
        id: uuid.v4(),
        customerId: customers[1].id,
        customerName: customers[1].name,
        items: [
          OrderItem(
            productId: products[2].id,
            productName: products[2].name,
            quantity: 15,
            unitPrice: products[2].price,
            discount: 200.0,
            total: (products[2].price * 15) - 200.0,
          ),
        ],
        subtotal: 4499.85,
        discount: 200.0,
        tax: 364.99,
        total: 4664.84,
        status: 'Pending',
        paymentStatus: 'Unpaid',
        paymentMethod: 'Cash',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Customer requested price match',
        salesRepId: 'REP001',
        isSynced: false,
      ),
    ];

    for (var order in orders) {
      await StorageService.saveOrder(order);
    }
  }

  static Future<void> _initializeSalesTargets() async {
    final target = SalesTarget(
      id: uuid.v4(),
      salesRepId: 'REP001',
      salesRepName: 'John Smith',
      monthlyTarget: 50000.0,
      currentAchievement: 32500.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
      targetCustomers: 30,
      visitedCustomers: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    await StorageService.saveSalesTarget(target);
  }

  static Future<void> _initializeTasks() async {
    final customers = await StorageService.getCustomers();
    if (customers.isEmpty) return;

    final tasks = [
      Task(
        id: uuid.v4(),
        title: 'Follow up on pending order',
        description: 'Contact customer about order confirmation',
        customerId: customers[0].id,
        customerName: customers[0].name,
        priority: 'High',
        status: 'Pending',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        assignedTo: 'REP001',
        isReminder: true,
        createdAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: 'Schedule product demo',
        description: 'Arrange demo for new product line',
        customerId: customers[1].id,
        customerName: customers[1].name,
        priority: 'Medium',
        status: 'In Progress',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        assignedTo: 'REP001',
        isReminder: false,
        createdAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: 'Collect payment',
        description: 'Collect outstanding payment for last month',
        customerId: customers[2].id,
        customerName: customers[2].name,
        priority: 'High',
        status: 'Pending',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assignedTo: 'REP001',
        isReminder: true,
        createdAt: DateTime.now(),
      ),
    ];

    for (var task in tasks) {
      await StorageService.saveTask(task);
    }
  }
}
