import 'package:flutter/foundation.dart';
import '../models/wallet.dart';

class WalletProvider with ChangeNotifier {
  Wallet _wallet = Wallet(
    id: 'w1',
    points: 150, // Default points for demo
    transactions: [
      WalletTransaction(
        id: 't1',
        title: 'Welcome Bonus',
        description: 'Signup bonus points',
        points: 100,
        date: DateTime.now().subtract(const Duration(days: 30)),
        orderId: '',
        type: TransactionType.earned,
      ),
      WalletTransaction(
        id: 't2',
        title: 'Order Reward',
        description: 'Points for order #o1',
        points: 35,
        date: DateTime.now().subtract(const Duration(days: 15)),
        orderId: 'o1',
        type: TransactionType.earned,
      ),
      WalletTransaction(
        id: 't3',
        title: 'Order Reward',
        description: 'Points for order #o2',
        points: 15,
        date: DateTime.now().subtract(const Duration(days: 10)),
        orderId: 'o2',
        type: TransactionType.earned,
      ),
    ],
  );

  Wallet get wallet => _wallet;

  double get totalPoints => _wallet.points;
  
  double get pointsInRupees => _wallet.pointsInRupees;

  List<WalletTransaction> get transactions => [..._wallet.transactions];

  void addPoints(double amount, String orderId) {
    // Calculate loyalty points (for every 50 rupees, 5 loyalty points are given)
    final loyaltyPoints = (amount / 50) * 5;
    
    final transaction = WalletTransaction(
      id: DateTime.now().toString(),
      title: 'Order Reward',
      description: 'Points for order #$orderId',
      points: loyaltyPoints,
      date: DateTime.now(),
      orderId: orderId,
      type: TransactionType.earned,
    );

    _wallet = Wallet(
      id: _wallet.id,
      points: _wallet.points + loyaltyPoints,
      transactions: [transaction, ..._wallet.transactions],
    );

    notifyListeners();
  }

  bool redeemPoints(double points, String purpose) {
    if (points > _wallet.points) {
      return false; // Not enough points
    }

    final transaction = WalletTransaction(
      id: DateTime.now().toString(),
      title: 'Redeemed Points',
      description: purpose,
      points: points,
      date: DateTime.now(),
      orderId: '',
      type: TransactionType.redeemed,
    );

    _wallet = Wallet(
      id: _wallet.id,
      points: _wallet.points - points,
      transactions: [transaction, ..._wallet.transactions],
    );

    notifyListeners();
    return true;
  }
} 