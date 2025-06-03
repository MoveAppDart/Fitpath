import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'step2_signup.dart';
import '../../providers/signup_flow_provider.dart';
import '../../widgets/signup/gradient_background.dart';
import '../../widgets/signup/progress_bar.dart';
import '../../widgets/signup/signup_header.dart';
import '../../widgets/signup/navigation_buttons.dart';
import '../../widgets/signup/signup_page_transition.dart';

class FirstStepSignup extends StatefulWidget {
  const FirstStepSignup({super.key});

  @override
  _FirstStepSignupState createState() => _FirstStepSignupState();
}

class _FirstStepSignupState extends State<FirstStepSignup> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider para acceder al estado del flujo de registro
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final String? selectedGender = signupFlowProvider.gender;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Barra de progreso reutilizable
            const SignupProgressBar(currentStep: 1, totalSteps: 6),

            const SizedBox(height: 40),

            // Título y subtítulo reutilizables
            const SignupHeader(
              title: "Let's get to know you",
              subtitle:
                  "Select your gender to personalize your fitness journey",
            ),

            const SizedBox(height: 30),

            // Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  GenderOptionButton(
                    label: "Male",
                    icon: Icons.male,
                    isSelected: selectedGender == "Male",
                    onPressed: () {
                      // Actualizar el género en el provider
                      signupFlowProvider.setGender("Male");
                    },
                  ),
                  GenderOptionButton(
                    label: "Female",
                    icon: Icons.female,
                    isSelected: selectedGender == "Female",
                    onPressed: () {
                      // Actualizar el género en el provider
                      signupFlowProvider.setGender("Female");
                    },
                  ),
                  GenderOptionButton(
                    label: "Non-Binary",
                    icon: Icons.transgender,
                    isSelected: selectedGender == "Non-Binary",
                    onPressed: () {
                      // Actualizar el género en el provider
                      signupFlowProvider.setGender("Non-Binary");
                    },
                  ),
                  GenderOptionButton(
                    label: "Prefer Not to disclose",
                    icon: Icons.close,
                    isSelected: selectedGender == "Prefer Not to disclose",
                    onPressed: () {
                      // Actualizar el género en el provider
                      signupFlowProvider.setGender("Prefer Not to disclose");
                    },
                  ),
                ],
              ),
            ),
            // Usar el componente reutilizable para botones de navegación
            SignupNavigationButtons(
              showPreviousButton: false, // Primer paso, no hay botón anterior
              disableNextButton: selectedGender == null,
              onNext: () {
                // Navegar al siguiente paso usando la transición personalizada
                Navigator.pushReplacement(
                  context,
                  SignupPageTransition(page: const SecondStepSignup()),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class GenderOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const GenderOptionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 45, 83, 181)
              : const Color.fromARGB(201, 255, 255, 255),
          padding: const EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSelected ? 10 : 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 126, 126, 126),
                size: 30),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 126, 126, 126),
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
