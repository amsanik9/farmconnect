import 'package:flutter/foundation.dart';
import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String status;
  final String paymentMethod;
  final String deliveryAddress;
  final String transactionId;
  final String estimatedDelivery;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.transactionId,
    required this.estimatedDelivery,
  });
} 