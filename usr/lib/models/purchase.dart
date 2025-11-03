class Purchase {
  final String id;
  final String itemName;
  final double price;
  final DateTime date;

  Purchase({
    required this.id,
    required this.itemName,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      itemName: map['itemName'],
      price: map['price'],
      date: DateTime.parse(map['date']),
    );
  }
}
