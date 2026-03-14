import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sky Store"),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => LoginScreen())
            );
          },
        ),
        actions: [
          IconButton(
            icon: Badge(label: Text("${context.watch<CartProvider>().itemCount}"), child: Icon(Icons.shopping_cart)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen())),
          )
        ],
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator()) 
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
              itemCount: products.length,
              itemBuilder: (ctx, i) => Card(
                child: InkWell(
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: products[i]))),
                  child: Column(children: [
                    Expanded(child: Image.network(products[i].image, fit: BoxFit.contain)),
                    Text(products[i].title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text("\$${products[i].price}"),
                    ElevatedButton(onPressed: () => context.read<CartProvider>().addToCart(products[i]), child: Text("Add to Cart"))
                  ]),
                ),
              ),
            ),
    );
  }
}