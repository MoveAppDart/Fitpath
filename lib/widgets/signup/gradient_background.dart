import 'package:flutter/material.dart';

/// Fondo con gradiente reutilizable para el flujo de registro
/// Proporciona un fondo consistente para todas las pantallas
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF005DC8),  // 0%
            Color(0xFF014594),  // 50%
            Color(0xFF01336D),  // 88%
            Color(0xFF022D60),  // 100%
          ],
          stops: [0.0, 0.5, 0.88, 1.0],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
