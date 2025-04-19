import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _baseUrl = 'https://api.stripe.com/v1';
  static const String _publishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
  static const String _secretKey = 'sk_test_YOUR_SECRET_KEY';
  static const String _testMode = 'true';

  // Function to create a payment intent
  static Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
    String description,
    String customerEmail,
  ) async {
    try {
      // In a real app, this would be a secure API call to your backend
      // which would then create a payment intent with Stripe
      // Never expose your secret key in your app
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': description,
        'receipt_email': customerEmail,
      };

      var response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      debugPrint('Error creating payment intent: $err');
      rethrow;
    }
  }

  // Mock function to process a payment
  // In a real app, this would integrate with Stripe SDK
  static Future<Map<String, dynamic>> processPayment({
    required String amount,
    required String currency,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required String name,
    required String email,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Validate card number (simple Luhn algorithm check)
      if (!_validateCardNumber(cardNumber)) {
        return {
          'success': false,
          'message': 'Invalid card number',
        };
      }

      // Validate expiry date
      if (!_validateExpiry(expMonth, expYear)) {
        return {
          'success': false,
          'message': 'Card expired',
        };
      }

      // In a real implementation, you would:
      // 1. Create a payment method with the card details
      // 2. Create a payment intent
      // 3. Confirm the payment intent with the payment method
      // 4. Handle 3D Secure if required

      // For demo purposes, we'll just return a success response
      return {
        'success': true,
        'message': 'Payment successful',
        'transaction_id': 'txn_${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'currency': currency,
      };
    } catch (e) {
      debugPrint('Error processing payment: $e');
      return {
        'success': false,
        'message': 'Payment failed: ${e.toString()}',
      };
    }
  }

  // Helper function to validate card number (simplified Luhn algorithm)
  static bool _validateCardNumber(String cardNumber) {
    // Remove any spaces or dashes
    cardNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if the card number is of reasonable length
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return false;
    }
    
    // Check if card is numeric
    if (!RegExp(r'^[0-9]+$').hasMatch(cardNumber)) {
      return false;
    }
    
    // For demo, accept any well-formed card number
    // In production, use proper Luhn algorithm validation
    return true;
  }

  // Helper function to validate expiry date
  static bool _validateExpiry(String month, String year) {
    try {
      final expMonth = int.parse(month);
      final expYear = int.parse(year);
      
      final now = DateTime.now();
      final currentYear = now.year;
      final currentMonth = now.month;
      
      // Check if year is 2-digit or 4-digit
      int fullYear = expYear;
      if (expYear < 100) {
        fullYear = 2000 + expYear;
      }
      
      // Check if card is expired
      if (fullYear < currentYear || 
         (fullYear == currentYear && expMonth < currentMonth)) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper function to calculate amount in smallest currency unit
  static String calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).toInt();
    return calculatedAmount.toString();
  }
} 