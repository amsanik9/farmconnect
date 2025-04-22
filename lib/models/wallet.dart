class Wallet {
  final String id;
  final double points;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.id,
    required this.points,
    required this.transactions,
  });

  double get pointsInRupees => points * 0.5; // 1 loyalty point = Rs. 0.5
}

class WalletTransaction {
  final String id;
  final String title;
  final String description;
  final double points;
  final DateTime date;
  final String orderId;
  final TransactionType type;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.date,
    required this.orderId,
    required this.type,
  });
}

enum TransactionType {
  earned,
  redeemed,
} 