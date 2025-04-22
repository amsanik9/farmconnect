import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [
    // Dummy orders
    OrderItem(
      id: 'o1',
      amount: 345.0,
      products: [
        CartItem(
          id: 'ci1',
          productId: 'p1',
          name: 'Fresh Tomatoes',
          quantity: 2,
          price: 30.0,
          imageUrl: 'https://images.unsplash.com/photo-1607305387299-a3d9611cd469',
          farmerName: 'Green Valley Farm',
          weight: 1.0,
          unit: 'kg',
        ),
        CartItem(
          id: 'ci2',
          productId: 'p6',
          name: 'Organic Spinach',
          quantity: 1,
          price: 170.0,
          imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb',
          farmerName: 'Green Valley Farm',
          weight: 1.0,
          unit: 'kg',
        ),
      ],
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Delivered',
      paymentMethod: 'Credit Card',
      deliveryAddress: '123 Main St, Mumbai, Maharashtra',
      transactionId: 'TXN1234567',
      estimatedDelivery: 'Delivered on Apr 15, 2024',
    ),
    OrderItem(
      id: 'o2',
      amount: 120.0,
      products: [
        CartItem(
          id: 'ci3',
          productId: 'p3',
          name: 'Red Apples',
          quantity: 1,
          price: 120.0,
          imageUrl: 'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a',
          farmerName: 'Orchard Hills',
          weight: 1.0,
          unit: 'kg',
        ),
      ],
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Delivered',
      paymentMethod: 'UPI',
      deliveryAddress: '456 Park Ave, Bangalore, Karnataka',
      transactionId: 'TXN7654321',
      estimatedDelivery: 'Delivered on Apr 12, 2024',
    ),
    OrderItem(
      id: 'o3',
      amount: 128.0,
      products: [
        CartItem(
          id: 'ci4',
          productId: 'p2',
          name: 'Fresh Potatoes',
          quantity: 2,
          price: 12.0,
          imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655',
          farmerName: 'Sunrise Farms',
          weight: 1.0,
          unit: 'kg',
        ),
        CartItem(
          id: 'ci5',
          productId: 'p4',
          name: 'Fresh Milk',
          quantity: 1,
          price: 58.0,
          imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b',
          farmerName: 'Meadow Dairy',
          weight: 1.0,
          unit: 'L',
        ),
        CartItem(
          id: 'ci6',
          productId: 'p1',
          name: 'Fresh Tomatoes',
          quantity: 1,
          price: 30.0,
          imageUrl: 'https://images.unsplash.com/photo-1607305387299-a3d9611cd469',
          farmerName: 'Green Valley Farm',
          weight: 1.0,
          unit: 'kg',
        ),
      ],
      dateTime: DateTime.now().subtract(const Duration(hours: 12)),
      status: 'Processing',
      paymentMethod: 'Cash on Delivery',
      deliveryAddress: '789 Rural Road, Pune, Maharashtra',
      transactionId: 'TXN9876543',
      estimatedDelivery: 'Expected by Apr 18, 2024',
    ),
  ];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total, String paymentMethod, 
      String deliveryAddress, String transactionId, String estimatedDelivery) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
        status: 'Processing',
        paymentMethod: paymentMethod,
        deliveryAddress: deliveryAddress,
        transactionId: transactionId,
        estimatedDelivery: estimatedDelivery,
      ),
    );
    notifyListeners();
  }

  List<OrderItem> getFilteredOrders(String status) {
    if (status == 'all' || status == null) {
      return orders;
    }
    return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
  }
} 