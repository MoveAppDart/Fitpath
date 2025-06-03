import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Importaciones de componentes y providers
import '../../providers/signup_flow_provider.dart';
import '../../widgets/signup/gradient_background.dart';
import '../../widgets/signup/progress_bar.dart';
import '../../widgets/signup/signup_header.dart';
import '../../widgets/signup/navigation_buttons.dart';
// Pantallas adyacentes
import './step2_signup.dart';
import './step4_signup.dart';

class ThirdStepSignup extends StatefulWidget {
  const ThirdStepSignup({super.key});

  @override
  _ThirdStepSignupState createState() => _ThirdStepSignupState();
}

class _ThirdStepSignupState extends State<ThirdStepSignup> {
  // Usaremos el sistema de medidas del provider para determinar si estamos usando KG o LB

  @override
  void initState() {
    super.initState();

    // Inicializar con un peso predeterminado si no existe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final signupFlowProvider =
          Provider.of<SignupFlowProvider>(context, listen: false);
      if (signupFlowProvider.weightKg == null) {
        signupFlowProvider.setWeight(70.0); // Valor predeterminado en KG
      }
    });
  }

  // Función para formatear el peso como string según la unidad
  String _getFormattedWeight(BuildContext context) {
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final bool isMetric = signupFlowProvider.useMetricSystem;

    if (isMetric) {
      return "${signupFlowProvider.weightKg?.toStringAsFixed(1) ?? '70.0'} kg";
    } else {
      return "${signupFlowProvider.weightLbs?.toStringAsFixed(1) ?? '154.3'} lbs";
    }
  }

  // Navegación a la pantalla anterior
  void _goToPreviousStep() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondStepSignup()),
      );
    }
  }

  // Navegación a la siguiente pantalla
  void _goToNextStep() {
    final signupFlowProvider =
        Provider.of<SignupFlowProvider>(context, listen: false);
    final weightKg = signupFlowProvider.weightKg ?? 70.0;

    // Validar que el peso esté dentro de un rango razonable
    if (weightKg < 30.0 || weightKg > 200.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese un peso entre 30kg y 200kg'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FourthStepSignup(weightKg: weightKg),
      ),
    );
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
                // Barra de progreso y encabezado en un contenedor con padding adaptativo
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: const Column(
                    children: [
                      // Barra de progreso reutilizable
                      SignupProgressBar(currentStep: 3, totalSteps: 6),

                      SizedBox(height: 20),

                      // Encabezado reutilizable
                      SignupHeader(
                        title: "Tell us about your weight",
                        subtitle: "This helps us calculate your fitness needs",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Selector de unidades en un contenedor elevado
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildUnitSelector(),
                      const SizedBox(height: 20),
                      // Texto con el peso seleccionado
                      Consumer<SignupFlowProvider>(
                        builder: (context, provider, _) => Text(
                          _getFormattedWeight(context),
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Slider para seleccionar peso
                      _buildWeightSlider(),
                    ],
                  ),
                ),

                // Espacio flexible para empujar botones hacia abajo
                const Spacer(),

                // Botones de navegación reutilizables
                SignupNavigationButtons(
                  onPrevious: _goToPreviousStep,
                  onNext: _goToNextStep,
                  disableNextButton:
                      Provider.of<SignupFlowProvider>(context).weightKg == null,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para construir el slider de selección de peso
  Widget _buildWeightSlider() {
    return Consumer<SignupFlowProvider>(
      builder: (context, signupFlowProvider, _) {
        final bool isMetric = signupFlowProvider.useMetricSystem;
        final currentValue = isMetric
            ? (signupFlowProvider.weightKg ?? 70.0)
            : (signupFlowProvider.weightLbs ?? 154.3);
        final minValue = isMetric ? 30.0 : (30.0 * 2.20462).roundToDouble();
        final maxValue = isMetric ? 200.0 : (200.0 * 2.20462).roundToDouble();

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // Slider con diseño mejorado
              Stack(
                alignment: Alignment.center,
                children: [
                  // Línea de fondo del slider
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Slider personalizado
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF00E676),
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.white,
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12.0,
                        elevation: 4.0,
                        pressedElevation: 8.0,
                      ),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 24.0),
                      overlayColor: const Color(0xFF00E676).withOpacity(0.2),
                      valueIndicatorColor: const Color(0xFF00E676),
                      valueIndicatorTextStyle: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Slider(
                      value: currentValue.clamp(minValue, maxValue),
                      min: minValue,
                      max: maxValue,
                      divisions: ((maxValue - minValue) * 2).toInt(),
                      label: isMetric
                          ? "${currentValue.toStringAsFixed(1)} kg"
                          : "${currentValue.toStringAsFixed(1)} lbs",
                      onChanged: (value) {
                        signupFlowProvider.setWeight(value, isMetric: isMetric);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Etiquetas de rango con mejor diseño
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isMetric ? "30 kg" : "66 lbs",
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      isMetric ? "200 kg" : "440 lbs",
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget para construir el selector de unidades (KG/LB)
  Widget _buildUnitSelector() {
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final bool isMetric = signupFlowProvider.useMetricSystem;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildUnitButton('KG', isMetric),
          Container(
            height: 24,
            width: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          _buildUnitButton('LB', !isMetric),
        ],
      ),
    );
  }

  Widget _buildUnitButton(String unit, bool isSelected) {
    final signupFlowProvider =
        Provider.of<SignupFlowProvider>(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            // Si estamos cambiando de sistema métrico, actualizamos el provider
            if ((unit == 'KG') != signupFlowProvider.useMetricSystem) {
              signupFlowProvider.toggleMeasurementSystem();
              setState(() {}); // Forzar actualizar la UI
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00E676) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              unit,
              style: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF001E3C) : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
