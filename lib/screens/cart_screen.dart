import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'Rs. ${cart.totalAmount.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {
                      // Check if cart is empty
                      if (cart.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your cart is empty!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      
                      // Navigate to checkout screen
                      Navigator.of(context).pushNamed(CheckoutScreen.routeName);
                    },
                    child: const Text('CHECKOUT'),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your cart is empty!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add items to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cart.items.values.toList()[i];
                      return Dismissible(
                        key: ValueKey(cartItem.id),
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          cart.removeItem(cart.items.keys.toList()[i]);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: cartItem.imageUrl,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                    placeholder: (context, url) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey[100],
                                      child: const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => 
                                      Container(
                                        width: 40,
                                        height: 40,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ),
                                ),
                              ),
                              title: Text(cartItem.name),
                              subtitle: Text(
                                cartItem.unit == 'dozen' ? 
                                'Total: Rs. ${(cartItem.price * cartItem.quantity).toInt()} (${cartItem.quantity} dozen)' :
                                'Total: Rs. ${(cartItem.price * cartItem.quantity).toInt()} (${cartItem.quantity} × ${cartItem.weight}${cartItem.unit})',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (cartItem.isNegotiated)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.green),
                                      ),
                                      child: Text(
                                        'Negotiated',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    color: Theme.of(context).colorScheme.error,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Remove Item'),
                                          content: Text('Remove ${cartItem.name} from your cart?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(ctx).pop(),
                                              child: const Text('CANCEL'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cart.removeItem(cartItem.productId);
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text('REMOVE'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Theme.of(context).colorScheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: cart.canReduceQuantity(cartItem.productId) 
                                      ? () => cart.removeSingleItem(cartItem.productId)
                                      : null,
                                    color: cart.canReduceQuantity(cartItem.productId) 
                                      ? null 
                                      : Colors.grey[400],
                                  ),
                                  Text('${cartItem.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => cart.addSingleItem(
                                      Provider.of<ProductsProvider>(context, listen: false).findById(cartItem.productId),
                                      negotiatedPrice: cartItem.isNegotiated ? cartItem.price : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 