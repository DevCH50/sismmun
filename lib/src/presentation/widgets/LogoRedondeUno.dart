import 'package:flutter/material.dart';

class LogoRedondoUno extends StatelessWidget {
  final double blurRadius;
  final double spreadRadius;
  final double paddingEdgeInsets;
  final double marginBottom;

  const LogoRedondoUno({
    super.key,
    required this.blurRadius,
    required this.spreadRadius,
    required this.paddingEdgeInsets,
    required this.marginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      padding: EdgeInsets.all(paddingEdgeInsets),
      margin: EdgeInsets.only(bottom: marginBottom),
      child: ClipOval(
        child: Image.asset(
          'assets/img/favicon-512-512.png',
          fit: BoxFit.contain,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
