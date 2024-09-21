import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (quantity > 1) {
              onChanged(quantity - 1);
            }
          },
          icon: const Icon(Icons.remove),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          onPressed: () {
            onChanged(quantity + 1);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}