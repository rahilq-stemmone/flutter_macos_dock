

import 'package:flutter/material.dart';

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start at top-left
    path.lineTo(size.width, 0); // Top-right
    path.lineTo(size.width, size.height - 20); // Bottom-right
    path.lineTo(size.width / 2 + 20, size.height - 20); // Right arrow
    path.lineTo(size.width / 2, size.height); // Arrow tip
    path.lineTo(size.width / 2 - 20, size.height - 20); // Left arrow
    path.lineTo(0, size.height - 20); // Bottom-left
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}