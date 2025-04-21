import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/farmer-orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Orders',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E603A),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search orders...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Filter by status',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Orders')),
                DropdownMenuItem(
                    value: 'processing', child: Text('Processing')),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildOrderCard(
                  orderNumber: 'ORD001',
                  customerName: 'John Doe',
                  items: 'Organic Tomatoes, Fresh Carrots',
                  total: 1250,
                  date: '2024-04-14',
                  status: 'Processing',
                ),
                _buildOrderCard(
                  orderNumber: 'ORD002',
                  customerName: 'Sarah Smith',
                  items: 'Green Peppers, Mangoes',
                  total: 950,
                  date: '2024-04-13',
                  status: 'Delivered',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String customerName,
    required String items,
    required int total,
    required String date,
    required String status,
  }) {
    Color statusColor;
    Color statusBackgroundColor;

    switch (status.toLowerCase()) {
      case 'processing':
        statusColor = Colors.blue;
        statusBackgroundColor = Colors.blue.withOpacity(0.1);
        break;
      case 'delivered':
        statusColor = Colors.green;
        statusBackgroundColor = Colors.green.withOpacity(0.1);
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusBackgroundColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBackgroundColor = Colors.grey.withOpacity(0.1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order #$orderNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Customer: $customerName',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Items: $items',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Total: ₹$total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E603A),
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement view details functionality
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement update status functionality
                    },
                    child: const Text('Update Status'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
