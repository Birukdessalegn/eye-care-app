import 'cart_item_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'].toString(),
    items: (json['items'] as List)
        .map(
          (item) =>
              CartItem(product: item['product'], quantity: item['quantity']),
        )
        .toList(),
    total: (json['total'] as num).toDouble(),
    date: DateTime.parse(json['date']),
    status: json['status'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items
        .map((e) => {'product': e.product.toJson(), 'quantity': e.quantity})
        .toList(),
    'total': total,
    'date': date.toIso8601String(),
    'status': status,
  };
}
