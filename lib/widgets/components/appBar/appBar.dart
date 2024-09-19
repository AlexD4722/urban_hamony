import 'package:flutter/material.dart';

class AppBarPage extends StatelessWidget {
  final String title;
  const AppBarPage({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
       title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
