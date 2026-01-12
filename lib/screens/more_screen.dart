import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileCard(context),
        const SizedBox(height: 24),
        _buildSectionTitle('Sales Tools'),
        _buildMenuItem(
          context,
          icon: Icons.location_on,
          title: 'GPS Check-In',
          subtitle: 'Track your customer visits',
          onTap: () => _handleCheckIn(context),
        ),
        _buildMenuItem(
          context,
          icon: Icons.route,
          title: 'Route Planning',
          subtitle: 'Optimize your daily route',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Route planning feature coming soon')),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.task,
          title: 'My Tasks',
          subtitle: 'Daily to-do list',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tasks feature coming soon')),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.qr_code_scanner,
          title: 'Barcode Scanner',
          subtitle: 'Scan product barcodes',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Barcode scanner feature coming soon')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Performance'),
        _buildMenuItem(
          context,
          icon: Icons.leaderboard,
          title: 'Leaderboard',
          subtitle: 'View team rankings',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Leaderboard feature coming soon')),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.analytics,
          title: 'Reports',
          subtitle: 'Sales analytics and insights',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reports feature coming soon')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Settings'),
        _buildMenuItem(
          context,
          icon: Icons.sync,
          title: 'Sync Data',
          subtitle: 'Sync offline data to server',
          onTap: () => _handleSyncData(context),
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings,
          title: 'App Settings',
          subtitle: 'Configure app preferences',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings feature coming soon')),
            );
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get assistance',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help feature coming soon')),
            );
          },
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Sales Master © 2024',
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              child: Text(
                'JS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'John Smith',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sales Representative',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: REP001',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile feature coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handleCheckIn(BuildContext context) async {
    // Check and request location permission
    final permission = await Permission.location.status;
    
    if (permission.isDenied) {
      final result = await Permission.location.request();
      if (result.isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required for check-in')),
          );
        }
        return;
      }
    }

    if (permission.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location permission in app settings'),
          ),
        );
      }
      return;
    }

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('GPS Check-In'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Location:'),
                const SizedBox(height: 8),
                Text('Latitude: ${position.latitude.toStringAsFixed(6)}'),
                Text('Longitude: ${position.longitude.toStringAsFixed(6)}'),
                Text('Accuracy: ${position.accuracy.toStringAsFixed(1)}m'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Check-in recorded successfully!')),
                  );
                },
                child: const Text('Check In'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    }
  }

  void _handleSyncData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Syncing data with server...'),
          ],
        ),
      ),
    );

    // Simulate sync operation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data synced successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
