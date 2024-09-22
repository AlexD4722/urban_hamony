import 'package:flutter/material.dart';
import '../widgets/screens/cart.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _demoCarts = [];

  List<Cart> get demoCarts => _demoCarts;

  void addCart(Cart cart) {
    _demoCarts.add(cart);
    notifyListeners();
  }

  void removeCart(int index) {
    _demoCarts.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var cart in _demoCarts) {
      total += (cart.product.price! * cart.numOfItem)!;
    }
    return total;
  }
}