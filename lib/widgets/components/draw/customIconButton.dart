import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String option;
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.title,
    this.color, required this.option,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveColor = (option == title) ? const Color(0xffe46b10) : const Color(
        0xff262424);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () => {onPressed()},
        child: Column(
          children: [
            Icon(icon, size: 25, color: effectiveColor),
            Text(title, style: TextStyle(fontSize: 13, color: effectiveColor)),
          ],
        ),
      ),
    );
  }
}
