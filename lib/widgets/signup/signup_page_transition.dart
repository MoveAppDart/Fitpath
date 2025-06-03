import 'dart:ui';
import 'package:flutter/material.dart';

/// Transición personalizada para navegación entre pasos de registro
/// Proporciona una transición fluida con efecto de desenfoque
class SignupPageTransition extends PageRouteBuilder {
  final Widget page;

  SignupPageTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;
            
            var fadeAnimation = Tween(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            );
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: (1.0 - animation.value) * 5.0,
                  sigmaY: (1.0 - animation.value) * 5.0,
                ),
                child: child,
              ),
            );
          },
        );
}
