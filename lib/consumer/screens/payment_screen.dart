import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/payment_service.dart';
import 'order_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';

  final double totalAmount;
  final String customerEmail;
  final String deliveryMethod;
  final double deliveryCharge;
  final double pointsRedeemed;

  const PaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.customerEmail,
    required this.deliveryMethod,
    required this.deliveryCharge,
    this.pointsRedeemed = 0.0,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

// Add a static method to extract arguments from the route settings
class PaymentScreenArguments {
  final double totalAmount;
  final String customerEmail;
  final String deliveryMethod;
  final double deliveryCharge;
  final double pointsRedeemed;

  PaymentScreenArguments({
    required this.totalAmount,
    required this.customerEmail,
    required this.deliveryMethod,
    required this.deliveryCharge,
    this.pointsRedeemed = 0.0,
  });

  static PaymentScreenArguments fromRoute(RouteSettings settings) {
    // Handle the case when arguments are null
    final args = settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Return default values if no arguments provided
      return PaymentScreenArguments(
        totalAmount: 0.0,
        customerEmail: '',
        deliveryMethod: 'Standard',
        deliveryCharge: 5.0,
        pointsRedeemed: 0.0,
      );
    }

    return PaymentScreenArguments(
      totalAmount: args['totalAmount'] ?? 0.0,
      customerEmail: args['customerEmail'] ?? '',
      deliveryMethod: args['deliveryMethod'] ?? 'Standard',
      deliveryCharge: args['deliveryCharge'] ?? 5.0,
      pointsRedeemed: args['pointsRedeemed'] ?? 0.0,
    );
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Card details
  String _cardNumber = '';
  String _expiryMonth = '';
  String _expiryYear = '';
  String _cvc = '';
  String _cardHolderName = '';

  // Payment result
  String _paymentResult = '';
  bool _paymentSuccess = false;

  // Card type
  String _cardType = '';

  // Arguments from route
  PaymentScreenArguments _arguments = PaymentScreenArguments(
    totalAmount: 0.0,
    customerEmail: '',
    deliveryMethod: 'Standard',
    deliveryCharge: 5.0,
    pointsRedeemed: 0.0,
  );

  @override
  void initState() {
    super.initState();
    // Initialize with widget properties
    _arguments = PaymentScreenArguments(
      totalAmount: widget.totalAmount,
      customerEmail: widget.customerEmail,
      deliveryMethod: widget.deliveryMethod,
      deliveryCharge: widget.deliveryCharge,
      pointsRedeemed: widget.pointsRedeemed,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      // Extract arguments from the route, but only if we haven't loaded from widget properties yet
      if (_arguments.totalAmount <= 0) {
        final routeSettings = ModalRoute.of(context)?.settings;
        if (routeSettings != null && routeSettings.arguments != null) {
          _arguments = PaymentScreenArguments.fromRoute(routeSettings);
        }
      }
    } catch (e) {
      print('Error in didChangeDependencies: $e');
    }
  }

  @override
  void dispose() {
    // Make sure we clean up properly
    super.dispose();
  }

  // Detect card type based on number
  String _getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('5')) {
      return 'MasterCard';
    } else if (cardNumber.startsWith('3')) {
      return 'American Express';
    } else if (cardNumber.startsWith('6')) {
      return 'Discover';
    }
    return '';
  }

  // Format card number with spaces
  String _formatCardNumber(String input) {
    if (input.isEmpty) return '';

    // Remove all non-digits
    String digits = input.replaceAll(RegExp(r'\D'), '');

    // Format based on card type
    String formatted = '';
    if (_cardType == 'American Express') {
      // Format: XXXX XXXXXX XXXXX
      for (var i = 0; i < digits.length; i++) {
        if (i == 4 || i == 10) formatted += ' ';
        formatted += digits[i];
      }
    } else {
      // Format: XXXX XXXX XXXX XXXX
      for (var i = 0; i < digits.length; i++) {
        if (i > 0 && i % 4 == 0) formatted += ' ';
        formatted += digits[i];
      }
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'Processing Payment...',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : _buildPaymentForm(),
    );
  }

  Widget _buildPaymentForm() {
    // Use either the arguments or widget property, whichever is available
    final totalAmount = _arguments.totalAmount > 0
        ? _arguments.totalAmount
        : widget.totalAmount;
    
    final pointsRedeemed = _arguments.pointsRedeemed > 0
        ? _arguments.pointsRedeemed
        : widget.pointsRedeemed;
    
    // Calculate subtotal (before points redemption)
    final subtotal = totalAmount + pointsRedeemed;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text('₹${(subtotal - _arguments.deliveryCharge).toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery (${_arguments.deliveryMethod}):'),
                          Text('₹${_arguments.deliveryCharge.toStringAsFixed(2)}'),
                        ],
                      ),
                      if (pointsRedeemed > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Loyalty Points Applied:',
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              '-₹${pointsRedeemed.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total to Pay:',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card Details
              Text(
                'Card Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.credit_card),
                  suffixIcon: _cardType.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _cardType,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                onChanged: (value) {
                  setState(() {
                    _cardNumber = value;
                    _cardType = _getCardType(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (value.length < 13) {
                    return 'Card number must be at least 13 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry Date and CVC
              Row(
                children: [
                  // Expiry Month
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Month (MM)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _expiryMonth = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final month = int.tryParse(value);
                        if (month == null || month < 1 || month > 12) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expiry Year
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Year (YY)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _expiryYear = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // CVC
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'CVC',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _cvc = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length < 3) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    _cardHolderName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the cardholder name';
                  }
                  return null;
                },
              ),

              // Error message
              if (_paymentResult.isNotEmpty && !_paymentSuccess)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    _paymentResult,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  child: Text(
                    'Pay Rs. ${totalAmount.toInt()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Secure payment note
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      'Secure Payment',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Accepted cards
              Center(
                child: Wrap(
                  spacing: 10,
                  children: [
                    Text('Accepted Cards:',
                        style: TextStyle(color: Colors.grey[600])),
                    Text('Visa', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('MasterCard',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('American Express',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _paymentResult = '';
      });

      try {
        // Simulate a brief delay for payment processing
        await Future.delayed(const Duration(seconds: 2));

        // Process payment using our payment service
        final result = await PaymentService.processPayment(
          amount: _arguments.totalAmount.toString(),
          currency: 'USD',
          cardNumber: _cardNumber,
          expMonth: _expiryMonth,
          expYear: _expiryYear,
          cvc: _cvc,
          name: _cardHolderName,
          email: _arguments.customerEmail,
        );

        setState(() {
          _isLoading = false;
        });

        if (result['success'] && mounted) {
          // Navigate to confirmation screen
          String deliveryMethodText = _arguments.deliveryMethod == 'Standard'
              ? 'Standard Delivery'
              : 'Express Delivery';

          String estimatedDelivery = DateTime.now()
              .add(Duration(
                  days: _arguments.deliveryMethod == 'Standard' ? 3 : 1))
              .toString()
              .substring(0, 10);

          // Use a push replacement to avoid stacking routes
          Navigator.of(context).pushReplacementNamed(
            OrderConfirmationScreen.routeName,
            arguments: {
              'transactionId': result['transaction_id'],
              'amount': _arguments.totalAmount,
              'customerEmail': _arguments.customerEmail.isNotEmpty
                  ? _arguments.customerEmail
                  : _cardHolderName + '@example.com',
              'deliveryMethod': deliveryMethodText,
              'estimatedDelivery': estimatedDelivery,
            },
          );
        } else if (mounted) {
          setState(() {
            _paymentSuccess = false;
            _paymentResult = result['message'];
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _paymentSuccess = false;
            _paymentResult = 'Payment failed: ${e.toString()}';
          });
        }
      }
    }
  }
}
