import 'package:flutter/material.dart';
import '../services/ecommerce_service.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';

class ShopScreen extends StatelessWidget {
  final EcommerceService ecommerceService = EcommerceService();

  ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ecommerceService.getProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 60),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(product.description),
              trailing: Text(
                '	${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                // Add to cart and go to cart screen
                ecommerceService.addToCart(product);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CartScreen(ecommerceService: ecommerceService),
                  ),
                );
              },
              // Add a trailing button for add to cart
              // trailing: ...existing code...
            ),
          );
        },
      ),
    );
  }
}
