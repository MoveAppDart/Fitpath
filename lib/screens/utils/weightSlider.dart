import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const greenColor = Color(0xff90D855);

class WeightSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  final bool isKG;

  const WeightSlider({
    required this.initialValue,
    required this.onChanged,
    this.isKG = true,
    super.key,
  });

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  PageController? numbersController;
  final itemsExtension = 1000;
  late double value;
  bool isUpdating = false;

  void _initializeController(double viewportFraction) {
    numbersController?.removeListener(_updateValue);
    numbersController?.dispose();
    numbersController = PageController(
      initialPage: itemsExtension + value.toInt(),
      viewportFraction: viewportFraction,
    );
    numbersController?.addListener(_updateValue);
  }

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    numbersController = PageController(
      initialPage: itemsExtension + value.toInt(),
      viewportFraction: 0.2,
    );
    numbersController?.addListener(_updateValue);
  }

  @override
  void didUpdateWidget(WeightSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isKG != widget.isKG ||
        oldWidget.initialValue != widget.initialValue) {
      value = widget.initialValue;
      isUpdating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        numbersController?.jumpToPage(itemsExtension + value.toInt());
        isUpdating = false;
      });
    }
  }

  void _updateValue() {
    if (isUpdating) return;

    final page = numbersController?.page ?? 0;
    final newValue = (page - itemsExtension).clamp(0, widget.isKG ? 250 : 551);

    if ((newValue - value).abs() > 0.01) {
      setState(() {
        value = newValue.toDouble();
      });
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(229, 255, 255, 255), // Fondo blanco translúcido
        borderRadius: BorderRadius.circular(30), // Bordes redondeados
        boxShadow: const [
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

          // Initialize controller with correct viewportFraction
          if (numbersController == null) {
            _initializeController(viewPortFraction * 10);
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              Text(
                value.toStringAsFixed(1),
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
                end: widget.isKG ? 250 : 551,
                selectedValue: value,
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
  final double selectedValue;

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
            selectedValue: selectedValue,
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
  final int index;
  final double selectedValue;

  const _Dividers({
    required this.index,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(10, (subIndex) {
          final isSelectedLine = (index + (subIndex - 5) / 10) == selectedValue;
          final isIntegerLine = subIndex == 5;

          final thickness = isSelectedLine ? 2.0 : 0.5;
          final lineHeight = (isSelectedLine || isIntegerLine) ? 30.0 : 10.0;

          final lineColor = isSelectedLine ? Colors.black : Colors.grey;

          return Expanded(
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(-thickness / 2, 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: lineHeight,
                    child: VerticalDivider(
                      thickness: thickness,
                      width: 1,
                      color: lineColor,
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
    super.parent,
  });

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
