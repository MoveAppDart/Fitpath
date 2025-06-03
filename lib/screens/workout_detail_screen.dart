import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/state_widgets.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import 'exercise_detail_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Workout? _workout;
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutDetails();
  }

  Future<void> _loadWorkoutDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      final success = await workoutProvider.getWorkoutDetails(widget.workoutId);
      
      if (!success) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = workoutProvider.error ?? 'No se encontró el entrenamiento';
        });
        return;
      }

      setState(() {
        _workout = workoutProvider.selectedWorkout;
        _exercises = workoutProvider.workoutExercises;
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

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(Exercise exercise, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _navigateToExerciseExecution(exercise, index),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagen del ejercicio
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          exercise.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.fitness_center,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.fitness_center,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
              ),
              const SizedBox(width: 16),
              // Información del ejercicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.description ?? 'Sin descripción',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: exercise.description == null ? FontStyle.italic : null,
                      ),
                    ),
                  ],
                ),
              ),
              // Icono de flecha
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          child: const Center(
            child: Icon(
              Icons.fitness_center,
              size: 80,
              color: Colors.white54,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Text(
              _workout?.name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.timer,
            '${_workout?.duration ?? 0} min',
            'Duración',
          ),
          _buildInfoItem(
            Icons.fitness_center,
            '${_exercises.length}',
            'Ejercicios',
          ),
          _buildInfoItem(
            Icons.whatshot,
            _workout?.type ?? 'General',
            'Tipo',
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _workout?.description ?? 'Sin descripción disponible',
            style: TextStyle(
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    if (_exercises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: EmptyState(
          message: 'No hay ejercicios en este entrenamiento',
          icon: Icons.fitness_center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ejercicios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercises.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final exercise = _exercises[index];
              return _buildExerciseItem(exercise, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingState(message: 'Cargando detalles del entrenamiento...');
    }

    if (_hasError) {
      return ErrorState(
        message: _errorMessage,
        onRetry: _loadWorkoutDetails,
      );
    }

    if (_workout == null) {
      return const EmptyState(
        message: 'No se encontró información del entrenamiento',
        icon: Icons.fitness_center,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutHeader(),
          _buildWorkoutInfo(),
          _buildWorkoutDescription(),
          _buildExercisesList(),
        ],
      ),
    );
  }

  void _startWorkout() {
    if (_exercises.isNotEmpty) {
      _navigateToExerciseExecution(_exercises.first, 0);
    }
  }

  void _navigateToExerciseExecution(Exercise exercise, int index) {
    // Navegar a la pantalla de detalles del ejercicio
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailScreen(
          exerciseId: exercise.id ?? '0',
          exercise: exercise, // Pasamos el ejercicio directamente para evitar otra llamada a la API
        ),
      ),
    );
    
    // Si prefieres navegar directamente a la pantalla de ejecución del ejercicio, 
    // descomenta el siguiente código y comenta o elimina el Navigator.push anterior
    /*
    final instructionsList = exercise.instructions ?? ['No hay instrucciones disponibles'];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseExecutionScreen(
          exerciseName: exercise.name,
          imageAsset: exercise.imageUrl ?? '',
          instructions: instructionsList,
          reps: 12, // Valor por defecto, se puede obtener de la configuración del ejercicio
          weight: '10kg', // Valor por defecto, se puede obtener de la configuración del ejercicio
          totalSets: 3, // Valor por defecto, se puede obtener de la configuración del ejercicio
        ),
      ),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_workout?.name ?? 'Detalles del entrenamiento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            color: _isFavorite ? Colors.red : null,
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              // TODO: Implementar funcionalidad para guardar favoritos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorite 
                    ? 'Añadido a favoritos' 
                    : 'Eliminado de favoritos'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _workout != null && _exercises.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _startWorkout,
              label: const Text('Comenzar'),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
