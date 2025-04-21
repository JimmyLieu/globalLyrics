import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double ? height;
  final Color? backgroundColor;

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.backgroundColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height ?? 80),
        backgroundColor: Colors.orange    ),
      child: Text(
        title
      )
    );
  }
}