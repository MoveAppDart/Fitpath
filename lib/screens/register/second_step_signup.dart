import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gymbro/screens/register/first_step_signup.dart';

class SecondStepSignup extends StatefulWidget {
  @override
  _SecondStepSignupState createState() => _SecondStepSignupState();
}

class _SecondStepSignupState extends State<SecondStepSignup> {
  final ScrollController _scrollController = ScrollController();
  final List<int> ages = List.generate(83, (index) => 18 + index); // Edades de 18 a 100
  int selectedAge = 18; // Edad seleccionada inicialmente

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Inicializar el scroll para que la edad inicial esté en el centro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToAge(selectedAge);
    });
  }

  void _onScroll() {
    // Calcular la edad seleccionada basada en la posición del scroll
    double centerOffset = _scrollController.offset + 75; // Ajusta según el tamaño del ítem
    int index = (centerOffset / 50).round(); // Ajusta según el tamaño del ítem
    index = index.clamp(0, ages.length - 1); // Asegurar que el índice esté dentro del rango

    setState(() {
      selectedAge = ages[index];
    });

    // Ajustar el scroll para que la edad seleccionada esté en el centro
    _scrollToAge(selectedAge);
  }

  void _scrollToAge(int age) {
    // Encontrar el índice de la edad seleccionada
    int index = ages.indexOf(age);
    if (index != -1) {
      // Calcular la posición del scroll para que la edad esté en el centro
      double offset = index * 50.0 - 75.0; // Ajusta según el tamaño del ítem
      _scrollController.jumpTo(offset); // Usar jumpTo para un ajuste instantáneo
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic size, heights, width;
    size = MediaQuery.of(context).size;
    heights = size.height;
    width = size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 93, 200),
                Color.fromARGB(255, 1, 69, 148),
                Color.fromARGB(255, 1, 51, 109),
                Color.fromARGB(255, 2, 45, 96),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: heights / 30),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      width: width / 8,
                      height: 5,
                      decoration: BoxDecoration(
                        color: index == 1
                            ? const Color.fromARGB(255, 10, 187, 37)
                            : const Color.fromARGB(255, 163, 172, 164),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: heights / 20),
              // Title and Subtitle
              Text(
                "What’s your Age?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heights / 40),
              Text(
                "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Morbi",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heights / 20),
              // Selector de Edad con Efecto de Escala
              Container(
                height: 277, // Altura del contenedor
                width: 118, // Ancho del contenedor
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: ages.length,
                  itemBuilder: (context, index) {
                    // Calcular la distancia desde el centro
                    double offset = (_scrollController.offset + 75 - index * 50).abs();
                    double scale = 1.0 - (offset / 150).clamp(0.0, 0.5); // Escala basada en la distancia
                    double opacity = 1.0 - (offset / 75).clamp(0.0, 0.5); // Opacidad basada en la distancia

                    // Mostrar solo 5 elementos (2 arriba, 1 en el centro, 2 abajo)
                    if (offset > 100) {
                      return SizedBox.shrink(); // Ocultar elementos fuera del rango
                    }

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              ages[index].toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: ages[index] == selectedAge
                                    ? Colors.blue // Resaltar la edad seleccionada
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: heights / 20),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                FirstStepSignup(),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: animation.value * 5,
                                      sigmaY: animation.value * 5),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 3.1416, // 90 grados en radianes (π/2)
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Previous",
                            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navegar a la siguiente pantalla con la edad seleccionada
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ThirdStepSignup(selectedAge: selectedAge),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: animation.value * 5,
                                      sigmaY: animation.value * 5),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(45, 124, 181, 1),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.fast_forward_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heights / 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdStepSignup extends StatelessWidget {
  final int selectedAge;

  const ThirdStepSignup({required this.selectedAge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Edad seleccionada: $selectedAge"),
      ),
    );
  }
}