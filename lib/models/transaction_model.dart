class TransactionModel {
  final String id;
  final String merchantName;
  final String date;
  final String location;
  final double amount;
  final String? iconUrl;

  const TransactionModel({
    required this.id,
    required this.merchantName,
    required this.date,
    required this.location,
    required this.amount,
    this.iconUrl,
  });

  String get formattedAmount {
    final isNegative = amount < 0;
    final absVal = amount.abs().toInt();
    final formatted = absVal.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return isNegative ? '-Rp$formatted' : 'Rp$formatted';
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      merchantName: json['merchantName'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      iconUrl: json['iconUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'date': date,
      'location': location,
      'amount': amount,
      'iconUrl': iconUrl,
    };
  }
}

