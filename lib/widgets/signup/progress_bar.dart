import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Barra de progreso reutilizable para el flujo de registro
/// Muestra visualmente el progreso del usuario a través de los pasos
class SignupProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double? width;

  const SignupProgressBar({
    Key? key,
    required this.currentStep,
    this.totalSteps = 6,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    
    // Calcular el ancho de cada elemento de progreso
    final double itemWidth = width ?? (screenWidth - 32) / totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Barra de progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              // Índice basado en 0, pero pasos basados en 1
              final step = index + 1;
              final bool isActive = step <= currentStep;
              
              return Container(
                width: itemWidth,
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: [
                    // Indicador de progreso (barra)
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive 
                            ? const Color(0xFF1B3AE5) // Color de acento principal
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          
          // Etiqueta del paso actual
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Step $currentStep of $totalSteps",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
