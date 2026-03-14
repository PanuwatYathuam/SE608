import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => _items;

  void addToCart(Product product) {
    int index = _items.indexWhere((i) => i.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeOneItem(int id) {
    int index = _items.indexWhere((i) => i.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  double get totalAmount => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
}
