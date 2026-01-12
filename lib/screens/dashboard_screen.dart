import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/storage_service.dart';
import '../models/sales_target.dart';
import '../models/order.dart';
import '../models/customer.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SalesTarget? _salesTarget;
  List<Order> _recentOrders = [];
  List<Customer> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final targets = await StorageService.getSalesTargets();
      final orders = await StorageService.getOrders();
      final customers = await StorageService.getCustomers();

      setState(() {
        _salesTarget = targets.isNotEmpty ? targets.first : null;
        _recentOrders = orders;
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 16),
          _buildSalesTargetCard(),
          const SizedBox(height: 16),
          _buildQuickStatsRow(),
          const SizedBox(height: 16),
          _buildSalesChartCard(),
          const SizedBox(height: 16),
          _buildRecentOrdersCard(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _salesTarget?.salesRepName ?? 'Sales Representative',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTargetCard() {
    if (_salesTarget == null) {
      return const SizedBox.shrink();
    }

    final percentage = _salesTarget!.achievementPercentage;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Target',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPerformanceColor(percentage).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: _getPerformanceColor(percentage),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPerformanceColor(percentage),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_salesTarget!.currentAchievement.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getPerformanceColor(percentage),
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_salesTarget!.monthlyTarget.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

  Widget _buildQuickStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            _recentOrders.length.toString(),
            Icons.shopping_cart,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Customers',
            _customers.length.toString(),
            Icons.people,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Visits',
            _salesTarget?.visitedCustomers.toString() ?? '0',
            Icons.location_on,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChartCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10000,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${(value / 1000).toInt()}k',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 25000),
                        FlSpot(1, 32000),
                        FlSpot(2, 28000),
                        FlSpot(3, 38000),
                        FlSpot(4, 42000),
                        FlSpot(5, 32500),
                      ],
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersCard() {
    if (_recentOrders.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No recent orders',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to orders screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(_recentOrders.take(3).map((order) => _buildOrderTile(order))),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTile(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt_long,
              color: _getStatusColor(order.status),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy').format(order.orderDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
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
    );
  }

  Color _getPerformanceColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
