import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;

  // Create separate form keys for each step
  final _formKey = GlobalKey<FormState>();
  final _shippingFormKey = GlobalKey<FormState>();

  // Form data
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _paymentMethod = 'Credit Card';
  String _deliveryMethod = 'Standard';
  double _standardDeliveryCharge = 5.0;
  double _expressDeliveryCharge = 10.0;

  // Get the current delivery charge based on selected method
  double get _deliveryCharge => 
      _deliveryMethod == 'Standard' ? _standardDeliveryCharge : _expressDeliveryCharge;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context) {
    // Navigate to payment screen
    Navigator.of(context).pushNamed(
      PaymentScreen.routeName,
      arguments: {
        'totalAmount':
            Provider.of<CartProvider>(context, listen: false).totalAmount +
            _deliveryCharge,
        'customerEmail': _emailController.text,
        'deliveryMethod': _deliveryMethod,
        'deliveryCharge': _deliveryCharge,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: (step) {
          if (step < _currentStep) {
            setState(() {
              _currentStep = step;
            });
          }
        },
        onStepContinue: () {
          print('Continue pressed, current step: $_currentStep');

          bool canContinue = true;

          // Handle validation based on current step
          if (_currentStep == 1) {
            // We're on the shipping info step, validate the form
            canContinue = _shippingFormKey.currentState?.validate() ?? false;
            print('Shipping form validation: $canContinue');
          }

          if (canContinue) {
            if (_currentStep < 2) {
              setState(() {
                _currentStep += 1;
              });
              print('Advanced to step ${_currentStep}');
            } else {
              _placeOrder(context);
              print('Placing order');
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Order Summary'),
            content: _buildOrderSummary(cart),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Shipping Information'),
            content: Form(key: _shippingFormKey, child: _buildShippingInfo()),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment'),
            content: _buildPaymentStep(cart),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items in your cart:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Item list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cart.items.length,
          itemBuilder: (ctx, i) {
            final cartItem = cart.items.values.toList()[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.imageUrl,
                    fit: BoxFit.cover,
                    width: 30,
                    height: 30,
                    placeholder:
                        (context, url) => Container(
                          width: 30,
                          height: 30,
                          color: Colors.grey[100],
                          child: const Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          width: 30,
                          height: 30,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 15,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),
              title: Text(cartItem.name),
              subtitle: Text(
                cartItem.unit == 'dozen' ? 
                '${cartItem.quantity} × Rs. ${cartItem.price.toInt()} / dozen' :
                '${cartItem.quantity} × Rs. ${cartItem.price.toInt()} / ${cartItem.weight}${cartItem.unit}',
              ),
              trailing: Text(
                'Rs. ${(cartItem.price * cartItem.quantity).toInt()}',
              ),
            );
          },
        ),
        const Divider(),
        // Total weight
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Weight:'),
              Text(
                '${cart.items.values.fold(0.0, (sum, item) => sum + (item.unit == 'dozen' ? 0 : item.weight * item.quantity)).toStringAsFixed(2)} kg',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Subtotal
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text(
                'Rs. ${cart.totalAmount.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Delivery fee
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee:'),
              Text('Rs. ${_deliveryCharge.toInt()}'),
            ],
          ),
        ),
        const Divider(),
        // Total
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs. ${(cart.totalAmount + _deliveryCharge).toInt()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        // Delivery method
        const SizedBox(height: 16),
        const Text(
          'Delivery Method:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RadioListTile(
          title: const Text('Standard Delivery (2-3 days)'),
          subtitle: Text('Rs. ${_standardDeliveryCharge.toInt()}'),
          value: 'Standard',
          groupValue: _deliveryMethod,
          onChanged: (value) {
            setState(() {
              _deliveryMethod = value.toString();
            });
          },
        ),
        RadioListTile(
          title: const Text('Express Delivery (1 day)'),
          subtitle: Text('Rs. ${_expressDeliveryCharge.toInt()}'),
          value: 'Express',
          groupValue: _deliveryMethod,
          onChanged: (value) {
            setState(() {
              _deliveryMethod = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget _buildShippingInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(
                  labelText: 'ZIP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentStep(CartProvider cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RadioListTile(
          title: const Text('Credit Card'),
          secondary: const Icon(Icons.credit_card),
          value: 'Credit Card',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value.toString();
            });
          },
        ),
        RadioListTile(
          title: const Text('PayPal'),
          secondary: const Icon(Icons.account_balance_wallet),
          value: 'PayPal',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value.toString();
            });
          },
        ),
        RadioListTile(
          title: const Text('Cash on Delivery'),
          secondary: const Icon(Icons.money),
          value: 'Cash on Delivery',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() {
              _paymentMethod = value.toString();
            });
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Order Summary:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Items Total:'),
            Text('Rs. ${cart.totalAmount.toInt()}'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Fee:'),
            Text('Rs. ${_deliveryCharge.toInt()}'),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rs. ${(cart.totalAmount + _deliveryCharge).toInt()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
