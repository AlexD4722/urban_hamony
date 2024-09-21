import 'package:flutter/material.dart';

import 'RoundedIconBtn.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({super.key});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedIconBtn(
          icon: Icons.remove,
          press: _decrementQuantity,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "$quantity",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        RoundedIconBtn(
          icon: Icons.add,
          showShadow: true,
          press: _incrementQuantity,
        ),
      ],
    );
  }
}
