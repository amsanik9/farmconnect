import 'package:flutter/foundation.dart';
import 'dart:math';

class Negotiation {
  final String id;
  final String productId;
  final String productName;
  final String imageUrl;
  final String farmerName;
  final double originalPrice;
  final double offeredPrice;
  final double? finalPrice;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime responseDeadline;

  Negotiation({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.farmerName,
    required this.originalPrice,
    required this.offeredPrice,
    this.finalPrice,
    required this.status,
    required this.createdAt,
    required this.responseDeadline,
  });
}

class NegotiationsProvider with ChangeNotifier {
  final List<Negotiation> _negotiations = [];

  List<Negotiation> get negotiations {
    return [..._negotiations];
  }

  List<Negotiation> getNegotiationsByStatus(String status) {
    return _negotiations.where((negotiation) => negotiation.status == status).toList();
  }

  void addNegotiation({
    required String productId,
    required String productName,
    required String imageUrl,
    required String farmerName,
    required double originalPrice,
    required double offeredPrice,
    required Duration responseTime,
  }) {
    final now = DateTime.now();
    final responseDeadline = now.add(responseTime);
    
    final negotiation = Negotiation(
      id: 'neg_${DateTime.now().millisecondsSinceEpoch}_$productId',
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      farmerName: farmerName,
      originalPrice: originalPrice,
      offeredPrice: offeredPrice,
      status: 'pending',
      createdAt: now,
      responseDeadline: responseDeadline,
    );
    
    _negotiations.add(negotiation);
    notifyListeners();
  }

  void updateNegotiationStatus(String negotiationId, String status, {double? finalPrice}) {
    final index = _negotiations.indexWhere((negotiation) => negotiation.id == negotiationId);
    if (index >= 0) {
      final negotiation = _negotiations[index];
      _negotiations[index] = Negotiation(
        id: negotiation.id,
        productId: negotiation.productId,
        productName: negotiation.productName,
        imageUrl: negotiation.imageUrl,
        farmerName: negotiation.farmerName,
        originalPrice: negotiation.originalPrice,
        offeredPrice: negotiation.offeredPrice,
        finalPrice: finalPrice ?? negotiation.finalPrice,
        status: status,
        createdAt: negotiation.createdAt,
        responseDeadline: negotiation.responseDeadline,
      );
      notifyListeners();
    }
  }

  void removeNegotiation(String negotiationId) {
    _negotiations.removeWhere((negotiation) => negotiation.id == negotiationId);
    notifyListeners();
  }

  // Simulates a response from the farmer
  void simulateFarmerResponse(String negotiationId) async {
    final random = Random();
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    final index = _negotiations.indexWhere((negotiation) => negotiation.id == negotiationId);
    if (index >= 0) {
      final negotiation = _negotiations[index];
      
      // 60% chance of acceptance, 40% chance of rejection
      final isAccepted = random.nextDouble() > 0.4;
      
      if (isAccepted) {
        // Calculate a final price between the original and offered price
        final priceDifference = negotiation.originalPrice - negotiation.offeredPrice;
        final randomFactor = random.nextDouble() * 0.7; // Random factor between 0 and 0.7
        final finalPrice = negotiation.originalPrice - (priceDifference * randomFactor);
        
        updateNegotiationStatus(
          negotiationId, 
          'accepted',
          finalPrice: double.parse(finalPrice.toStringAsFixed(2)),
        );
      } else {
        updateNegotiationStatus(negotiationId, 'rejected');
      }
    }
  }
} 