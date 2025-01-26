import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const greenColor = Color(0xff90D855);

class WeightSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const WeightSlider({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  PageController? numbersController;
  final itemsExtension = 1000;
  late double value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  void _updateValue() {
    final double newValue = ((((numbersController?.page ?? 0) - itemsExtension) * 10)
                .roundToDouble() /
            10)
        .clamp(0, 250);

    if (newValue != value) {
      setState(() {
        value = newValue; // Ahora newValue es double
      });
      widget.onChanged(value); // Notificar al padre el nuevo valor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                  color: Color.fromARGB(229, 255, 255, 255), // Fondo blanco translúcido
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewPortFraction = 1 / (constraints.maxWidth / 10);
          numbersController = PageController(
            initialPage: itemsExtension + widget.initialValue.toInt(),
            viewportFraction: viewPortFraction * 10,
          );
          numbersController?.addListener(_updateValue);
          return Column(
            children: [
              const SizedBox(height: 10),
              Text(
                '${value.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 10,
                width: 11.5,
                child: CustomPaint(
                  painter: TrianglePainter(),
                ),
              ),
              const SizedBox(height: 10),
              _Numbers(
                itemsExtension: itemsExtension,
                controller: numbersController,
                start: 0,
                end: 250,
                selectedValue: value, // Pasar el valor seleccionado
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    numbersController?.removeListener(_updateValue);
    numbersController?.dispose();
    super.dispose();
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 45, 124, 181);

    canvas.drawPath(_getTrianglePath(size.width, size.height), paint);
  }

  Path _getTrianglePath(double x, double y) {
    return Path()
      ..lineTo(x, 0)
      ..lineTo(x / 2, y)
      ..lineTo(0, 0);
  }

  Path _linePath(double x, double y) {
    return Path()
      ..moveTo(x / 2, 0)
      ..lineTo(x / 2, y * 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Numbers extends StatelessWidget {
  final PageController? controller;
  final int itemsExtension;
  final int start;
  final int end;
  final double selectedValue; // Valor seleccionado en el slider

  const _Numbers({
    required this.controller,
    required this.itemsExtension,
    required this.start,
    required this.end,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: PageView.builder(
        pageSnapping: false,
        controller: controller,
        physics: _CustomPageScrollPhysics(
          start: itemsExtension + start.toDouble(),
          end: itemsExtension + end.toDouble(),
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, rawIndex) {
          final index = rawIndex - itemsExtension;
          return _Item(
            index: index >= start && index <= end ? index : null,
            selectedValue: selectedValue, // Pasar el valor seleccionado
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final int? index;
  final double selectedValue;

  const _Item({
    required this.index,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          if (index != null)
            _Dividers(
              index: index!,
              selectedValue: selectedValue,
            ),
        ],
      ),
    );
  }
}

class _Dividers extends StatelessWidget {
  final int index; // Índice actual
  final double selectedValue; // Valor seleccionado en el slider

  const _Dividers({
    required this.index,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20, // Altura base del contenedor
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(10, (subIndex) {
          // Determinar si esta línea es la seleccionada
          final isSelectedLine = (index + (subIndex - 5) / 10) == selectedValue;
          // Determinar si es una línea de número entero
          final isIntegerLine = subIndex == 5;

          // Grosor y altura de la línea
          final thickness = isSelectedLine ? 2.0 : 0.5;
          final lineHeight = (isSelectedLine || isIntegerLine) ? 30.0 : 10.0;

          // Color de la línea
          final lineColor = isSelectedLine ? Colors.black : Colors.grey;

          return Expanded(
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(-thickness / 2, 0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200), // Duración de la animación
                    height: lineHeight, // Altura de la línea
                    child: VerticalDivider(
                      thickness: thickness,
                      width: 1,
                      color: lineColor, // Color de la línea
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CustomPageScrollPhysics extends ScrollPhysics {
  final double start;
  final double end;

  const _CustomPageScrollPhysics({
    required this.start,
    required this.end,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  _CustomPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CustomPageScrollPhysics(
      parent: buildParent(ancestor),
      start: start,
      end: end,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final frictionSimulation =
        FrictionSimulation(0.4, position.pixels, velocity * 0.2);
    double newPosition = (frictionSimulation.finalX / 10).round() * 10;

    final endPosition = end * 10 * 10;
    final startPosition = start * 10 * 10;
    newPosition = newPosition.clamp(startPosition, endPosition);

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      newPosition.toDouble(),
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 20,
        stiffness: 100,
        damping: 0.8,
      );
}