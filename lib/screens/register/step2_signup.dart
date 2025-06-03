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
import './step1_signup.dart';
import './step3_signup.dart';

class SecondStepSignup extends StatefulWidget {
  const SecondStepSignup({super.key});

  @override
  _SecondStepSignupState createState() => _SecondStepSignupState();
}

class _SecondStepSignupState extends State<SecondStepSignup> {
  final List<int> _ages = List.generate(87, (index) => 14 + index); // Edades de 14 a 100
  late FixedExtentScrollController _scrollController;

  // Constantes para el diseño del picker
  static const double _itemExtent = 50.0;
  static const double _pickerHeight = 220.0; // Altura del área visible del picker
  static const int _numberOfVisibleItems = 5; // Número de items visibles para padding

  @override
  void initState() {
    super.initState();
    
    // Inicializar el controller después de obtener el age del provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final signupFlowProvider = Provider.of<SignupFlowProvider>(context, listen: false);
      final currentAge = signupFlowProvider.age ?? 25; // Usar 25 como edad por defecto si no hay valor
      
      // Encontrar el índice en la lista de edades
      int initialItemIndex = _ages.indexOf(currentAge);
      if (initialItemIndex == -1) {
        initialItemIndex = _ages.indexOf(25); // Fallback a 25 años
      }
      
      // Mover el picker a la posición inicial
      _scrollController.jumpToItem(initialItemIndex);
    });
    
    // Inicializar el controller con un valor temporal
    _scrollController = FixedExtentScrollController(initialItem: _ages.indexOf(25));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Navegación a la pantalla anterior
  void _goToPreviousStep() {
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const FirstStepSignup()),
    );
  }

  // Navegación a la siguiente pantalla
  void _goToNextStep() {
    // Guardar la edad seleccionada en el provider antes de navegar
    final signupFlowProvider = Provider.of<SignupFlowProvider>(context, listen: false);
    final int selectedAge = _ages[_scrollController.selectedItem];
    
    // Actualizar la edad en el provider
    signupFlowProvider.setAge(selectedAge);
    
    // Navegar al tercer paso usando la transición personalizada
    Navigator.pushReplacement(
      context,
      SignupPageTransition(page: const ThirdStepSignup()),
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
                const SizedBox(height: 40),
                
                // Barra de progreso reutilizable
                const SignupProgressBar(currentStep: 2, totalSteps: 6),
                
                const SizedBox(height: 30),
                
                // Encabezado reutilizable
                const SignupHeader(
                  title: "How old are you?",
                  subtitle: "This helps us personalize your workouts and diet plan.",
                ),
                
                const SizedBox(height: 40),
                
                // Selector de edad (personalizado con estilo)
                _buildAgePicker(),
                
                // Espacio flexible para empujar botones hacia abajo
                const Spacer(),
                
                // Botones de navegación reutilizables
                SignupNavigationButtons(
                  onPrevious: _goToPreviousStep,
                  onNext: _goToNextStep,
                  // El botón Next estará deshabilitado si no hay una edad seleccionada
                  disableNextButton: Provider.of<SignupFlowProvider>(context).age == null,
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgePicker() {
    return Container(
      height: _pickerHeight,
      width: 120, // Ancho fijo para el selector
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1), // Fondo oscuro semitransparente
        borderRadius: BorderRadius.circular(20), // Bordes más suaves
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Indicador de selección (rectángulo central resaltado)
          Container(
            height: _itemExtent,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
                bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
              ),
            ),
          ),
          
          // Picker de edad
          CupertinoPicker(
            scrollController: _scrollController,
            itemExtent: _itemExtent,
            onSelectedItemChanged: (index) {
              if (mounted) {
                // Actualizar el valor seleccionado en el provider
                final signupFlowProvider = Provider.of<SignupFlowProvider>(context, listen: false);
                signupFlowProvider.setAge(_ages[index]);
              }
            },
            diameterRatio: 1.2, // Ajusta para cambiar la curvatura
            magnification: 1.2, // Ligero zoom en el elemento central
            useMagnifier: true,
            squeeze: 1.1, // Compresión de los items no seleccionados
            selectionOverlay: null, // Quitar el overlay por defecto
            children: List.generate(_ages.length, (index) {
              // Para determinar cuál item está seleccionado usando el provider
              final signupFlowProvider = Provider.of<SignupFlowProvider>(context);
              final bool isSelected = (signupFlowProvider.age == _ages[index]);
              
              return Center(
                child: Text(
                  _ages[index].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: isSelected ? 28 : 20, // Más grande si está seleccionado
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

