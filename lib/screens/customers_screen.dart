import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterType = 'All';

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customers = await StorageService.getCustomers();
      setState(() {
        _customers = customers;
        _filteredCustomers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCustomers() {
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        final matchesSearch = customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            customer.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            customer.phone.contains(_searchQuery);
        final matchesType = _filterType == 'All' || customer.customerType == _filterType;
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCustomers.isEmpty
                    ? _buildEmptyState()
                    : _buildCustomerList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add new customer
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add customer feature coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterCustomers();
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Retail'),
                _buildFilterChip('Wholesale'),
                _buildFilterChip('Distributor'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterType == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterType = label;
          });
          _filterCustomers();
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
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first customer to get started',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList() {
    return RefreshIndicator(
      onRefresh: _loadCustomers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredCustomers.length,
        itemBuilder: (context, index) {
          return _buildCustomerCard(_filteredCustomers[index]);
        },
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          _showCustomerDetails(customer);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _getTypeColor(customer.customerType).withValues(alpha: 0.2),
                    child: Text(
                      customer.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(customer.customerType),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor(customer.customerType).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      customer.customerType,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(customer.customerType),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.phone,
                      customer.phone,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.location_city,
                      customer.city,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outstanding',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '\$${customer.outstandingBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last Visit',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('MMM d').format(customer.lastVisitDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Retail':
        return Colors.blue;
      case 'Wholesale':
        return Colors.green;
      case 'Distributor':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showCustomerDetails(Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: _getTypeColor(customer.customerType).withValues(alpha: 0.2),
                      child: Text(
                        customer.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(customer.customerType),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getTypeColor(customer.customerType).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              customer.customerType,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getTypeColor(customer.customerType),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.email, 'Email', customer.email),
                _buildDetailRow(Icons.phone, 'Phone', customer.phone),
                _buildDetailRow(Icons.location_on, 'Address', customer.address),
                _buildDetailRow(Icons.location_city, 'City', customer.city),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildFinanceCard(
                        'Credit Limit',
                        '\$${customer.creditLimit.toStringAsFixed(0)}',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFinanceCard(
                        'Outstanding',
                        '\$${customer.outstandingBalance.toStringAsFixed(0)}',
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (customer.notes.isNotEmpty) ...[
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(customer.notes),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Create order
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Create order feature coming soon')),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Create Order'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Check-in
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Check-in feature coming soon')),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Check In'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
