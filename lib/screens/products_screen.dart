import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    try {
      final products = await StorageService.getProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.sku.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _filterCategory == 'All' || product.category == _filterCategory;
        return matchesSearch && matchesCategory && product.isActive;
      }).toList();
    });
  }

  Set<String> _getCategories() {
    return {'All', ..._products.map((p) => p.category).toSet()};
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
                : _filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductsGrid(),
          ),
        ],
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
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _filterProducts();
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _getCategories()
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: _filterCategory == category,
                          onSelected: (selected) {
                            setState(() => _filterCategory = category);
                            _filterProducts();
                          },
                          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No products found', style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) => _buildProductCard(_filteredProducts[index]),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(Icons.inventory_2, size: 64, color: Colors.grey[400]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.discount > 0) ...[
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '\$${product.finalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ] else
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.stockQuantity > 20
                              ? Colors.green.withValues(alpha: 0.2)
                              : product.stockQuantity > 0
                                  ? Colors.orange.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${product.stockQuantity}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: product.stockQuantity > 20
                                ? Colors.green
                                : product.stockQuantity > 0
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
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
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.inventory_2, size: 100, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(product.description, style: TextStyle(color: Colors.grey[700])),
                const Divider(height: 32),
                _buildDetailRow('SKU', product.sku),
                _buildDetailRow('Barcode', product.barcode),
                _buildDetailRow('Unit', product.unit),
                _buildDetailRow('Stock Quantity', '${product.stockQuantity} units'),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 4),
                          if (product.discount > 0) ...[
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '\$${product.finalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            Text(
                              '${product.discount.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ] else
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Stock Status', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: product.stockQuantity > 20
                                ? Colors.green.withValues(alpha: 0.2)
                                : product.stockQuantity > 0
                                    ? Colors.orange.withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.stockQuantity > 20
                                ? 'In Stock'
                                : product.stockQuantity > 0
                                    ? 'Low Stock'
                                    : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: product.stockQuantity > 20
                                  ? Colors.green
                                  : product.stockQuantity > 0
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: product.stockQuantity > 0
                        ? () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add to cart feature coming soon')),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
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
}
