import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("ตะกร้าสินค้าของคุณ")),
      body: cart.items.isEmpty 
        ? Center(child: Text("ไม่มีสินค้าในตะกร้า"))
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => ListTile(
                    leading: Image.network(cart.items[i].image, width: 50),
                    title: Text(cart.items[i].title, maxLines: 1),
                    subtitle: Text("\$${cart.items[i].price} x ${cart.items[i].quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => cart.removeOneItem(cart.items[i].id)),
                        IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => cart.removeItem(cart.items[i].id)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ราคารวมทั้งหมด:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("\$${cart.totalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
    );
  }
}