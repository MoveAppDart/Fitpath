import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../providers/workout_provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final Exercise? exercise; // Opcional: si ya tenemos el ejercicio

  const ExerciseDetailScreen({
    Key? key,
    required this.exerciseId,
    this.exercise,
  }) : super(key: key);

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Exercise? _exercise;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    // Si ya tenemos el ejercicio, lo usamos directamente
    if (widget.exercise != null) {
      setState(() {
        _exercise = widget.exercise;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Obtener detalles del ejercicio desde el provider
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      final exercise = await workoutProvider.getExerciseDetails(widget.exerciseId);
      
      if (exercise == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No se encontró el ejercicio';
        });
        return;
      }

      setState(() {
        _exercise = exercise;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar los detalles: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_exercise?.name ?? 'Detalle del Ejercicio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExerciseDetails,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_exercise == null) {
      return const Center(child: Text('No se encontró información del ejercicio'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del ejercicio
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Text(
              _exercise!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Imagen del ejercicio con músculos resaltados
          Container(
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: _exercise!.imageUrl != null && _exercise!.imageUrl!.isNotEmpty
                ? Image.network(
                    _exercise!.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fitness_center,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                : const Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
          
          // Instrucciones del ejercicio
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E4F0), // Color azul claro como en la imagen
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Instrucciones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF003366), // Azul oscuro
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Color(0xFF003366)),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_exercise!.instructions != null && _exercise!.instructions!.isNotEmpty)
                  ...List.generate(
                    _exercise!.instructions!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2), // Azul
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _exercise!.instructions![index],
                              style: const TextStyle(
                                color: Color(0xFF1976D2), // Azul
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Text(
                    'No hay instrucciones disponibles para este ejercicio.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          
          // Información adicional del ejercicio
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalles del Ejercicio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Tipo de ejercicio', _exercise!.type),
                _buildInfoRow('Músculo objetivo', _exercise!.targetMuscle),
                if (_exercise!.difficultyLevel != null)
                  _buildInfoRow('Nivel de dificultad', _exercise!.difficultyLevel!),
                if (_exercise!.equipment != null && _exercise!.equipment!.isNotEmpty)
                  _buildInfoRow('Equipamiento', _exercise!.equipment!.join(', ')),
                if (_exercise!.description != null && _exercise!.description!.isNotEmpty) ...[  
                  const SizedBox(height: 16),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_exercise!.description!),
                ],
              ],
            ),
          ),
          
          // Botón para comenzar el ejercicio
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de ejecución del ejercicio
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseExecutionScreen(
                        exerciseName: _exercise!.name,
                        imageAsset: _exercise!.imageUrl ?? '',
                        instructions: _exercise!.instructions ?? ['No hay instrucciones disponibles'],
                        reps: 12, // Valor por defecto
                        weight: '10kg', // Valor por defecto
                        totalSets: 3, // Valor por defecto
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Comenzar Ejercicio',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}