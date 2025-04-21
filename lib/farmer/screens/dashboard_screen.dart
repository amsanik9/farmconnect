import 'package:flutter/material.dart';
import 'package:farmconnect/consumer/screens/negotiations_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/farmer-dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button
          title: const Text('Dashboard'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Farmer!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E603A),
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatCard(
                  title: 'Total Products',
                  value: '24',
                  percentageChange: '+12%',
                  icon: Icons.inventory_2,
                  iconBackgroundColor: const Color(0xFF2E603A),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const NegotiationsScreen()),
                    );
                  },
                  child: _buildStatCard(
                    title: 'Active Orders',
                    value: '8',
                    percentageChange: '+25%',
                    icon: Icons.shopping_cart,
                    iconBackgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  title: 'Monthly Sales',
                  value: '₹45,000',
                  percentageChange: '+18%',
                  icon: Icons.trending_up,
                  iconBackgroundColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  title: 'Sales Growth',
                  value: '22%',
                  percentageChange: null,
                  icon: Icons.bar_chart,
                  iconBackgroundColor: const Color(0xFF8B4513),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    String? percentageChange,
    required IconData icon,
    required Color iconBackgroundColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (percentageChange != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          percentageChange,
                          style: TextStyle(
                            fontSize: 14,
                            color: percentageChange.startsWith('+')
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
}
