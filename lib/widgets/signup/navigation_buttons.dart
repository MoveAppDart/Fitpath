import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botones de navegación reutilizables para el flujo de registro
class SignupNavigationButtons extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool disableNextButton;
  final String nextButtonText;
  final String previousButtonText;
  final bool showPreviousButton;

  const SignupNavigationButtons({
    Key? key,
    required this.onNext,
    this.onPrevious,
    this.disableNextButton = false,
    this.nextButtonText = "Continue",
    this.previousButtonText = "Previous",
    this.showPreviousButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón "Previous" - Solo visible si se especifica
          if (showPreviousButton)
            TextButton.icon(
              icon: Transform.rotate(
                angle: 3.14159, // 180 grados
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
              ),
              label: Text(
                previousButtonText,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: onPrevious,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            // Espacio vacío para mantener la alineación cuando no hay botón anterior
            const SizedBox(width: 120),
            
          // Botón "Continue"
          ElevatedButton.icon(
            icon: Text(
              nextButtonText,
              style: GoogleFonts.poppins(
                color: disableNextButton ? Colors.grey[700] : const Color(0xFF022D60),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            label: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
            onPressed: disableNextButton ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: disableNextButton ? Colors.grey[300] : Colors.white,
              foregroundColor: const Color(0xFF022D60),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}
