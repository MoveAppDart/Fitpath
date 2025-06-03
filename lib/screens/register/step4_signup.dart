import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import 'step3_signup.dart';
import 'step5_signup.dart';

class FourthStepSignup extends StatefulWidget {
  final double weightKg;
  const FourthStepSignup({super.key, required this.weightKg});

  @override
  _FourthStepSignupState createState() => _FourthStepSignupState();
}

class _FourthStepSignupState extends State<FourthStepSignup> {
  // Controladores para el picker de altura
  final FixedExtentScrollController _cmController =
      FixedExtentScrollController();
  final FixedExtentScrollController _feetController =
      FixedExtentScrollController();
  final FixedExtentScrollController _inchesController =
      FixedExtentScrollController();

  // Rangos de altura
  final List<int> _cmValues =
      List.generate(171, (index) => 130 + index); // 130cm - 300cm
  final List<int> _feetValues =
      List.generate(4, (index) => 4 + index); // 4ft - 7ft
  final List<int> _inchesValues =
      List.generate(12, (index) => index); // 0in - 11in

  // Altura del picker
  final double _pickerHeight = 160;
  final double _itemExtent = 40;

  @override
  void initState() {
    super.initState();

    // Inicializar con valores predeterminados o existentes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signupFlowProvider =
          Provider.of<SignupFlowProvider>(context, listen: false);

      // Si ya hay altura almacenada, posicionar los controladores
      if (signupFlowProvider.heightCm != null) {
        final int heightCm = signupFlowProvider.heightCm!;
        _scrollToCm(heightCm);
      } else {
        // Valor predeterminado: 170cm
        signupFlowProvider.setHeight(170);
        _scrollToCm(170);
      }
    });
  }

  // Método para posicionar el picker en un valor específico en cm
  void _scrollToCm(int cm) {
    final int cmIndex = _cmValues.indexOf(cm);
    if (cmIndex != -1) {
      _cmController.jumpToItem(cmIndex);
    }
  }

  // Método para posicionar el picker en valores imperiales (pies/pulgadas)
  void _scrollToImperial(int feet, int inches) {
    final int feetIndex = _feetValues.indexOf(feet);
    final int inchesIndex = _inchesValues.indexOf(inches);

    if (feetIndex != -1) {
      _feetController.jumpToItem(feetIndex);
    }

    if (inchesIndex != -1) {
      _inchesController.jumpToItem(inchesIndex);
    }
  }

  @override
  void dispose() {
    _cmController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  // Navegación a la pantalla anterior
  void _goToPreviousStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const ThirdStepSignup()),
    );
  }

  // Navegación a la siguiente pantalla
  void _goToNextStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const FifthStepSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Acceder al provider para detectar cambios
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final bool isMetric = signupFlowProvider.useMetricSystem;

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
                const SignupProgressBar(currentStep: 4, totalSteps: 6),

                const SizedBox(height: 30),

                // Encabezado reutilizable
                const SignupHeader(
                  title: "How tall are you?",
                  subtitle:
                      "This helps us calculate your BMI and fitness needs",
                ),

                const SizedBox(height: 20),

                // Selector de unidades (métrico/imperial)
                _buildUnitSelector(),

                const SizedBox(height: 40),

                // Selector de altura según sistema métrico
                isMetric ? _buildCmPicker() : _buildFeetInchesPicker(),

                // Texto con la altura seleccionada
                Text(
                  _getHeightDisplayString(signupFlowProvider),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                // Espacio flexible para empujar botones hacia abajo
                const Spacer(),

                // Botones de navegación reutilizables
                SignupNavigationButtons(
                  onPrevious: _goToPreviousStep,
                  onNext: _goToNextStep,
                  disableNextButton: signupFlowProvider.heightCm == null,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Obtener string con formato de altura para mostrar
  String _getHeightDisplayString(SignupFlowProvider provider) {
    if (provider.heightCm == null) {
      return provider.useMetricSystem ? "170 cm" : "5'7\"";
    }

    if (provider.useMetricSystem) {
      return "${provider.heightCm} cm";
    } else {
      // Convertir cm a pies/pulgadas para mostrar
      final int totalInches = (provider.heightCm! * 0.393701).round();
      final int feet = totalInches ~/ 12;
      final int inches = totalInches % 12;
      return "$feet'$inches\"";
    }
  }

  // Widget para construir el selector de unidades (CM/FT)
  Widget _buildUnitSelector() {
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
    final bool isMetric = signupFlowProvider.useMetricSystem;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUnitButton('CM', isMetric),
          _buildUnitButton('FT', !isMetric),
        ],
      ),
    );
  }

  // Widget para construir los botones del selector de unidades
  Widget _buildUnitButton(String unit, bool isSelected) {
    final signupFlowProvider =
        Provider.of<SignupFlowProvider>(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            // Si estamos cambiando de sistema métrico, actualizamos el provider
            if ((unit == 'CM') != signupFlowProvider.useMetricSystem) {
              signupFlowProvider.toggleMeasurementSystem();

              // Actualizar la posición de los pickers según el nuevo sistema
              if (unit == 'CM') {
                final int heightCm = signupFlowProvider.heightCm ?? 170;
                _scrollToCm(heightCm);
              } else {
                final int heightCm = signupFlowProvider.heightCm ?? 170;
                final int totalInches = (heightCm * 0.393701).round();
                final int feet = totalInches ~/ 12;
                final int inches = totalInches % 12;
                _scrollToImperial(feet, inches);
              }

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

  // Selector de altura en centímetros
  Widget _buildCmPicker() {
    final signupFlowProvider =
        Provider.of<SignupFlowProvider>(context, listen: false);

    return Container(
      height: _pickerHeight,
      width: 120,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: CupertinoPicker(
        scrollController: _cmController,
        itemExtent: _itemExtent,
        onSelectedItemChanged: (index) {
          if (mounted) {
            signupFlowProvider.setHeight(_cmValues[index]);
          }
        },
        diameterRatio: 1.2,
        magnification: 1.2,
        useMagnifier: true,
        selectionOverlay: null,
        children: List.generate(_cmValues.length, (index) {
          final bool isSelected =
              (signupFlowProvider.heightCm == _cmValues[index]);
          return Center(
            child: Text(
              "${_cmValues[index]}",
              style: GoogleFonts.poppins(
                fontSize: isSelected ? 26 : 18,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }),
      ),
    );
  }

  // Selector de altura en pies y pulgadas
  Widget _buildFeetInchesPicker() {
    final signupFlowProvider =
        Provider.of<SignupFlowProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selector de pies
        Container(
          height: _pickerHeight,
          width: 90,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: CupertinoPicker(
            scrollController: _feetController,
            itemExtent: _itemExtent,
            onSelectedItemChanged: (feetIndex) {
              if (mounted) {
                // Obtener pulgadas actuales
                final int inchesIndex = _inchesController.selectedItem;
                final int feet = _feetValues[feetIndex];
                final int inches = _inchesValues[inchesIndex];

                // Convertir a cm y actualizar provider
                final int heightCm = ((feet * 12 + inches) * 2.54).round();
                signupFlowProvider.setHeight(heightCm, isMetric: false);
              }
            },
            diameterRatio: 1.2,
            magnification: 1.2,
            useMagnifier: true,
            selectionOverlay: null,
            children: List.generate(_feetValues.length, (index) {
              return Center(
                child: Text(
                  "${_feetValues[index]} ft",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ),

        // Selector de pulgadas
        Container(
          height: _pickerHeight,
          width: 90,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: CupertinoPicker(
            scrollController: _inchesController,
            itemExtent: _itemExtent,
            onSelectedItemChanged: (inchesIndex) {
              if (mounted) {
                // Obtener pies actuales
                final int feetIndex = _feetController.selectedItem;
                final int feet = _feetValues[feetIndex];
                final int inches = _inchesValues[inchesIndex];

                // Convertir a cm y actualizar provider
                final int heightCm = ((feet * 12 + inches) * 2.54).round();
                signupFlowProvider.setHeight(heightCm, isMetric: false);
              }
            },
            diameterRatio: 1.2,
            magnification: 1.2,
            useMagnifier: true,
            selectionOverlay: null,
            children: List.generate(_inchesValues.length, (index) {
              return Center(
                child: Text(
                  "${_inchesValues[index]} in",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
