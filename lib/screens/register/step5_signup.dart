import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Importaciones de componentes y providers
import '../../providers/signup_flow_provider.dart';
import '../../widgets/signup/gradient_background.dart';
import '../../widgets/signup/progress_bar.dart';
import '../../widgets/signup/signup_header.dart';
import '../../widgets/signup/navigation_buttons.dart';
import '../../widgets/signup/signup_page_transition.dart';

// Pantallas adyacentes
import 'step4_signup.dart';
import 'step6_signup.dart';

class FifthStepSignup extends StatefulWidget {
  const FifthStepSignup({super.key});

  @override
  _FifthStepSignupState createState() => _FifthStepSignupState();
}

class _FifthStepSignupState extends State<FifthStepSignup> {
  // Los niveles de actividad disponibles
  final List<ActivityOption> _activityOptions = [
    ActivityOption(
        label: "Sedentary",
        icon: Icons.weekend_outlined,
        description: "Little to no exercise"),
    ActivityOption(
        label: "Lightly Active",
        icon: Icons.directions_walk_outlined,
        description: "Light exercise 1-3 days a week"),
    ActivityOption(
        label: "Moderately Active",
        icon: Icons.directions_run_outlined,
        description: "Moderate exercise 3-5 days a week"),
    ActivityOption(
        label: "Very Active",
        icon: Icons.fitness_center_outlined,
        description: "Hard exercise 6-7 days a week"),
    ActivityOption(
        label: "Professional Athlete",
        icon: Icons.sports_gymnastics_outlined,
        description: "Hard exercise twice a day"),
  ];

  // Navegación a la pantalla anterior
  void _goToPreviousStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(
        page: FourthStepSignup(
            weightKg: Provider.of<SignupFlowProvider>(context, listen: false)
                    .weightKg ??
                70.0),
      ),
    );
  }

  // Navegación a la siguiente pantalla
  void _goToNextStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const SixthStepSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Acceder al provider para detectar cambios
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final String? selectedActivity = signupFlowProvider.fitnessLevel;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Barra de progreso reutilizable
                const SignupProgressBar(currentStep: 5, totalSteps: 6),

                const SizedBox(height: 30),

                // Encabezado reutilizable
                const SignupHeader(
                  title: "What's your activity level?",
                  subtitle: "This helps us determine your daily calorie needs",
                ),

                const SizedBox(height: 20),

                // Lista de opciones de actividad
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _activityOptions.length,
                    itemBuilder: (context, index) {
                      final option = _activityOptions[index];
                      return ActivityOptionButton(
                        label: option.label,
                        icon: option.icon,
                        description: option.description,
                        isSelected: selectedActivity == option.label,
                        onPressed: () {
                          if (mounted) {
                            signupFlowProvider.setFitnessLevel(option.label);
                          }
                        },
                      );
                    },
                  ),
                ),

                // Botones de navegación reutilizables
                SignupNavigationButtons(
                  onPrevious: _goToPreviousStep,
                  onNext: _goToNextStep,
                  disableNextButton: selectedActivity == null,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Clase para almacenar las opciones de actividad
class ActivityOption {
  final String label;
  final IconData icon;
  final String description;

  ActivityOption({
    required this.label,
    required this.icon,
    required this.description,
  });
}

// Widget para mostrar un botón de opción de actividad
class ActivityOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? description;
  final bool isSelected;
  final VoidCallback onPressed;

  const ActivityOptionButton({
    super.key,
    required this.label,
    required this.icon,
    this.description,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: isSelected ? 8 : 2,
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2D57B5)
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2D57B5).withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icono con círculo de fondo
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : const Color(0xFFEEF2F5),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : const Color(0xFF2D57B5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Textos descriptivos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF2D3748),
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : const Color(0xFF718096),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Indicador de selección
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
