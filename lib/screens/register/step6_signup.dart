import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Importaciones de componentes y providers
import '../../providers/signup_flow_provider.dart';
import '../../widgets/signup/gradient_background.dart';
import '../../widgets/signup/progress_bar.dart';
import '../../widgets/signup/signup_header.dart';
import '../../widgets/signup/signup_page_transition.dart';

// Pantallas adyacentes
import '../bottom_navbar.dart';
import 'step5_signup.dart';

// Clase para almacenar las opciones de objetivos
class FitnessGoalOption {
  final String label;
  final IconData icon;
  final String description;

  FitnessGoalOption({
    required this.label,
    required this.icon,
    required this.description,
  });
}

// Widget para mostrar un botón de opción de objetivo
class GoalOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onPressed;

  const GoalOptionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.description,
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
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFF718096),
                        ),
                      ),
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

class SixthStepSignup extends StatefulWidget {
  const SixthStepSignup({super.key});

  @override
  State<SixthStepSignup> createState() => _SixthStepSignupState();
}

class _SixthStepSignupState extends State<SixthStepSignup> {
  // Los objetivos de fitness disponibles
  final List<FitnessGoalOption> _fitnessGoals = [
    FitnessGoalOption(
        label: "Lose Weight",
        icon: Icons.fitness_center,
        description: "Reduce body fat and get leaner"),
    FitnessGoalOption(
        label: "Build Muscle",
        icon: Icons.sports_gymnastics,
        description: "Increase strength and muscle mass"),
    FitnessGoalOption(
        label: "Improve Endurance",
        icon: Icons.directions_run,
        description: "Enhance cardiovascular fitness"),
    FitnessGoalOption(
        label: "Stay Active",
        icon: Icons.directions_bike,
        description: "Maintain a healthy lifestyle"),
    FitnessGoalOption(
        label: "Overall Fitness",
        icon: Icons.health_and_safety,
        description: "Balance of strength, endurance, and flexibility"),
  ];

  // Variable para mantener el objetivo seleccionado actualmente
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    // Verificar si ya hay un objetivo guardado en el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SignupFlowProvider>(context, listen: false);
      if (provider.fitnessGoals != null && provider.fitnessGoals!.isNotEmpty) {
        setState(() {
          _selectedGoal = provider.fitnessGoals!.first;
        });
      }
    });
  }

  // Navegación a la pantalla anterior
  void _goToPreviousStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const FifthStepSignup()),
    );
  }

  // Navegación a la pantalla principal después de finalizar el registro
  void _finishSignup() {
    // Aquí se podría agregar lógica para enviar los datos al backend
    // o realizar cualquier otra acción necesaria al finalizar el registro

    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const BottomNavbar()),
    );
  }

  // Método para actualizar el objetivo seleccionado
  void _selectGoal(String goalLabel) {
    setState(() {
      _selectedGoal = goalLabel;
    });

    // Actualizar el provider con el nuevo objetivo
    final provider = Provider.of<SignupFlowProvider>(context, listen: false);
    provider.setFitnessGoals([goalLabel]);
  }

  @override
  Widget build(BuildContext context) {
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
                const SignupProgressBar(currentStep: 6, totalSteps: 6),

                const SizedBox(height: 30),

                // Encabezado reutilizable
                const SignupHeader(
                  title: "What's your goal?",
                  subtitle: "This helps us create a customized plan for you",
                ),

                const SizedBox(height: 20),

                // Lista de opciones de objetivos
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _fitnessGoals.length,
                    itemBuilder: (context, index) {
                      final goal = _fitnessGoals[index];
                      return GoalOptionButton(
                        label: goal.label,
                        icon: goal.icon,
                        description: goal.description,
                        isSelected: _selectedGoal == goal.label,
                        onPressed: () => _selectGoal(goal.label),
                      );
                    },
                  ),
                ),

                // Botones de navegación
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón para ir al paso anterior
                      TextButton.icon(
                        onPressed: _goToPreviousStep,
                        icon: Transform.rotate(
                          angle: 3.1416,
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white),
                        ),
                        label: const Text(
                          "Previous",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // Botón para finalizar el registro
                      ElevatedButton(
                        onPressed: _selectedGoal == null ? null : _finishSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D7CB5),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFF2D7CB5).withOpacity(0.5),
                          disabledForegroundColor: Colors.white60,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Finish"),
                            SizedBox(width: 8),
                            Icon(Icons.check_circle_outline, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
