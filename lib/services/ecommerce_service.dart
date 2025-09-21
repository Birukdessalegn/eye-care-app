import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class EcommerceService {
  // Mock product list
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Blue Light Glasses',
      description: 'Protect your eyes from screen glare.',
      price: 29.99,
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9',
      category: 'Glasses',
    ),
    Product(
      id: '2',
      name: 'Eye Drops',
      description: 'Relieve dry eyes and irritation.',
      price: 12.50,
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      category: 'Care',
    ),
    Product(
      id: '3',
      name: 'Contact Lens Solution',
      description: 'Keep your lenses clean and safe.',
      price: 8.99,
      imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b',
      category: 'Care',
    ),
  ];

  final List<CartItem> _cart = [];
  final List<Order> _orders = [];

  List<Product> getProducts() => List.unmodifiable(_products);

  List<CartItem> getCart() => List.unmodifiable(_cart);

  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((item) => item.product.id == product.id);
  }

  void updateCartQuantity(Product product, int quantity) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity = quantity;
      if (quantity <= 0) {
        _cart.removeAt(index);
      }
    }
  }

  double getCartTotal() {
    return _cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Order checkout() {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List<CartItem>.from(_cart),
      total: getCartTotal(),
      date: DateTime.now(),
      status: 'Processing',
    );
    _orders.add(order);
    _cart.clear();
    return order;
  }

  List<Order> getOrders() => List.unmodifiable(_orders);
}
