class TransactionModel {
  int? id;
  String userId; 
  String type; 
  double amount;
  String category;
  String note;
  DateTime date;
  String currency;

  TransactionModel({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.currency
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'currency': currency
    };
  }

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['userId'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      currency: map['currency'],
    );
  }
}
