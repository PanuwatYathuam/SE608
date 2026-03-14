import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายละเอียดสินค้า")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.image, height: 300, fit: BoxFit.contain),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("\$${product.price}", style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Text(product.description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, minimumSize: Size(double.infinity, 50)),
          onPressed: () {
            context.read<CartProvider>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("เพิ่มลงตะกร้าแล้ว!")));
          },
          child: Text("เพิ่มลงตะกร้าสินค้า"),
        ),
      ),
    );
  }
}