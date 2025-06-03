import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Encabezado reutilizable para las pantallas de registro
/// Muestra el título y subtítulo con un estilo coherente
class SignupHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignupHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double verticalSpacing = screenSize.height * 0.02;
    
    // Tamaños de texto responsivos
    final double titleFontSize = screenWidth * 0.065;
    final double subtitleFontSize = screenWidth * 0.038;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: verticalSpacing * 0.5),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
