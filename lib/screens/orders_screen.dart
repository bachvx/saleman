import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  bool _isLoading = true;
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    
    try {
      final orders = await StorageService.getOrders();
      setState(() {
        _orders = orders..sort((a, b) => b.orderDate.compareTo(a.orderDate));
        _filteredOrders = _orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = _filterStatus == 'All'
          ? _orders
          : _orders.where((order) => order.status == _filterStatus).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create order feature coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All'),
            _buildFilterChip('Pending'),
            _buildFilterChip('Confirmed'),
            _buildFilterChip('Shipped'),
            _buildFilterChip('Delivered'),
            _buildFilterChip('Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _filterStatus = label);
          _filterOrders();
        },
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text('Create your first order to get started', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) => _buildOrderCard(_filteredOrders[index]),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.receipt_long, color: _getStatusColor(order.status)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order #${order.id.substring(0, 8)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, yyyy - HH:mm').format(order.orderDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.inventory_2_outlined, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return Colors.green;
      case 'pending': return Colors.orange;
      case 'cancelled': return Colors.red;
      case 'shipped': return Colors.blue;
      case 'delivered': return Colors.purple;
      default: return Colors.grey;
    }
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Order Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Order #${order.id.substring(0, 8)}', style: TextStyle(color: Colors.grey[600])),
                const Divider(height: 32),
                _buildDetailRow('Customer', order.customerName),
                _buildDetailRow('Order Date', DateFormat('MMM d, yyyy - HH:mm').format(order.orderDate)),
                _buildDetailRow('Status', order.status),
                _buildDetailRow('Payment Status', order.paymentStatus),
                _buildDetailRow('Payment Method', order.paymentMethod),
                if (order.notes.isNotEmpty) _buildDetailRow('Notes', order.notes),
                const Divider(height: 32),
                const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...order.items.map((item) => _buildItemTile(item)),
                const Divider(height: 32),
                _buildSummaryRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}', false),
                _buildSummaryRow('Discount', '-\$${order.discount.toStringAsFixed(2)}', false),
                _buildSummaryRow('Tax', '\$${order.tax.toStringAsFixed(2)}', false),
                _buildSummaryRow('Total', '\$${order.total.toStringAsFixed(2)}', true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isBold) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
