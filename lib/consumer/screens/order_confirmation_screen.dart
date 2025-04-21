import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static const routeName = '/order-confirmation';

  final String transactionId;
  final double amount;
  final String customerEmail;
  final String deliveryMethod;
  final String estimatedDelivery;

  const OrderConfirmationScreen({
    Key? key,
    required this.transactionId,
    required this.amount,
    required this.customerEmail,
    required this.deliveryMethod,
    required this.estimatedDelivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Clear the cart
    Future.delayed(Duration.zero, () {
      Provider.of<CartProvider>(context, listen: false).clear();
    });

    // Debug - print received values
    print('OrderConfirmation - Amount: $amount');
    print('OrderConfirmation - Email: $customerEmail');
    print('OrderConfirmation - TransactionID: $transactionId');
    print('OrderConfirmation - DeliveryMethod: $deliveryMethod');
    print('OrderConfirmation - EstimatedDelivery: $estimatedDelivery');

    return PopScope(
      // Prevent back button from going back to payment screen
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmed'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Success icon
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 24),
                // Thank you message
                Text(
                  'Thank You for Your Order!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your order has been confirmed and will be shipped soon.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Order details card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Confirmed',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        _buildDetailRow('Transaction ID', transactionId),
                        _buildDetailRow('Amount', 'Rs. ${amount.toInt()}'),
                        _buildDetailRow(
                            'Email',
                            customerEmail.isEmpty
                                ? 'Not provided'
                                : customerEmail),
                        _buildDetailRow('Delivery Method', deliveryMethod),
                        _buildDetailRow(
                            'Estimated Delivery', estimatedDelivery),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Tracking info
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What Happens Next?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildStepRow(1, 'Order Processing',
                            'We\'re preparing your order for shipment.'),
                        _buildStepRow(2, 'Order Shipped',
                            'Your order will be shipped within 24-48 hours.'),
                        _buildStepRow(3, 'Order Delivery',
                            'Your order will be delivered to your address.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Return to home button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(int step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade700,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
