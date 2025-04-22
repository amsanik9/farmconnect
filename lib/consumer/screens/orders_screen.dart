import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/orders_provider.dart';
import '../../models/order.dart';
import '../../l10n/app_localizations.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/consumer-orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? _selectedStatus = 'all';
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    final filteredOrders = ordersData.getFilteredOrders(_selectedStatus ?? 'all');
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              appLocalizations.myOrders,
              style: const TextStyle(
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
                hintText: appLocalizations.searchOrders,
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
              decoration: InputDecoration(
                labelText: appLocalizations.filterByStatus,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(appLocalizations.allOrders)),
                DropdownMenuItem(
                    value: 'processing', child: Text(appLocalizations.processing)),
                DropdownMenuItem(value: 'delivered', child: Text(appLocalizations.delivered)),
                DropdownMenuItem(value: 'cancelled', child: Text(appLocalizations.cancelled)),
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
            child: filteredOrders.isEmpty
                ? Center(
                    child: Text(
                      appLocalizations.noOrdersFound,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredOrders.length,
                    itemBuilder: (ctx, i) => OrderCard(
                      order: filteredOrders[i],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final OrderItem order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    Color statusColor;
    Color statusBackgroundColor;

    switch (widget.order.status.toLowerCase()) {
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${appLocalizations.order} #${widget.order.id}',
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
                        widget.order.status,
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
                  '${appLocalizations.date}: ${DateFormat('MMM dd, yyyy').format(widget.order.dateTime)}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appLocalizations.items}: ${widget.order.products.length}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${appLocalizations.total}: ₹${widget.order.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E603A),
                      ),
                    ),
                    Text(
                      widget.order.estimatedDelivery,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    '${appLocalizations.transactionId}: ${widget.order.transactionId}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${appLocalizations.paymentMethod}: ${widget.order.paymentMethod}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${appLocalizations.deliveryAddress}: ${widget.order.deliveryAddress}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Divider(),
                  Text(
                    '${appLocalizations.orderItems}:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.order.products.length,
                    itemBuilder: (ctx, i) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.order.products[i].name} x${widget.order.products[i].quantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '₹${(widget.order.products[i].price * widget.order.products[i].quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.support_agent),
                        label: Text(appLocalizations.contactSupport),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Implement contact support
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 