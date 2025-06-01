import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'step1_signup.dart';
import 'step3_signup.dart';

class SecondStepSignup extends StatefulWidget {
  const SecondStepSignup({super.key});

  @override
  _SecondStepSignupState createState() => _SecondStepSignupState();
}

class _SecondStepSignupState extends State<SecondStepSignup> {
  final ScrollController _scrollController = ScrollController();
  final List<int> ages =
      List.generate(87, (index) => 14 + index); // Edades de 18 a 100
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
    double centerOffset =
        _scrollController.offset + 75; // Ajusta según el tamaño del ítem
    int index = (centerOffset / 50).round(); // Ajusta según el tamaño del ítem
    index = index.clamp(
        0, ages.length - 1); // Asegurar que el índice esté dentro del rango

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
      double offset = index * 51.0 - 75.0; // Ajusta según el tamaño del ítem
      _scrollController
          .jumpTo(offset); // Usar jumpTo para un ajuste instantáneo
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
                            : const Color.fromARGB(178, 163, 172, 164),
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
                height: 277, // Altura total ajustada del selector
                width: 116, // Ancho del selector
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                      229, 255, 255, 255), // Fondo blanco translúcido
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Líneas de borde para el elemento seleccionado
                    Positioned(
                      top: 105, // Posición de la línea superior
                      left: 0,
                      right: 0,
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.black26,
                      ),
                    ),
                    Positioned(
                      top: 155, // Posición de la línea inferior
                      left: 0,
                      right: 0,
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.black26,
                      ),
                    ),
                    CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: ages.indexOf(selectedAge)),
                      itemExtent: 51.0, // Altura de cada elemento
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedAge = ages[index];
                        });
                      },
                      children: List.generate(ages.length, (index) {
                        final currentIndex = index;
                        final selectedIndex = ages.indexOf(selectedAge);
                        final distanceFromCenter =
                            (currentIndex - selectedIndex).abs();

                        // Calcular el tamaño de fuente en función de la distancia
                        double fontSize;
                        if (distanceFromCenter == 0) {
                          fontSize = 26; // Elemento central
                        } else if (distanceFromCenter == 1) {
                          fontSize = 20; // Inmediatamente arriba/abajo
                        } else if (distanceFromCenter == 2) {
                          fontSize = 15; // Dos posiciones arriba/abajo
                        } else {
                          fontSize =
                              12; // Valores más lejanos visibles pero pequeños
                        }

                        return Center(
                          child: Text(
                            ages[index].toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: distanceFromCenter == 0
                                  ? Colors.black // Elemento central en negro
                                  : Color.fromARGB(255, 158, 158,
                                      158), // Elementos secundarios en gris
                              fontWeight: distanceFromCenter == 0
                                  ? FontWeight
                                      .bold // Elemento central en negrita
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              // Buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // For Previous button
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirstStepSignup()),
                        );

                        // For Next button
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ThirdStepSignup()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 3.1416,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Previous",
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ThirdStepSignup(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
