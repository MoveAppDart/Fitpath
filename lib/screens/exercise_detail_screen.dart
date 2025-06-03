import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpath/services/api/wger_service.dart';
import 'package:fitpath/services/api/api_client.dart';
import 'package:fitpath/models/exercise.dart';
import 'package:fitpath/screens/exercise_execution_screen.dart';
import 'package:dio/dio.dart';

// Provider para el estado del detalle del ejercicio (usa String como ID)
final exerciseDetailProvider = StateNotifierProvider.family<ExerciseDetailNotifier, AsyncValue<Exercise?>, String>((ref, exerciseId) {
  // Crear un cliente HTTP específico para WGER
  final dio = Dio(BaseOptions(
    baseUrl: 'https://wger.de/api/v2/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  final apiClient = ApiClient(dio: dio);
  final wgerService = WgerService(apiClient);
  return ExerciseDetailNotifier(wgerService, exerciseId);
});

class ExerciseDetailNotifier extends StateNotifier<AsyncValue<Exercise?>> {
  final WgerService _wgerService;
  final String exerciseId;
  
  ExerciseDetailNotifier(this._wgerService, this.exerciseId) : super(const AsyncValue.loading()) {
    _loadExerciseDetails();
  }
  
  Future<void> _loadExerciseDetails() async {
    state = const AsyncValue.loading();
    try {
      // Convertir el ID a int para la API de WGER
      final wgerId = int.tryParse(exerciseId) ?? 0;
      if (wgerId <= 0) {
        throw Exception('ID de ejercicio no válido: $exerciseId');
      }
      
      final exercise = await _wgerService.getExerciseDetails(wgerId);
      state = AsyncValue.data(exercise);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
  
  Future<void> refresh() => _loadExerciseDetails();
}

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  final Exercise? exercise;

  const ExerciseDetailScreen({
    Key? key,
    required this.exerciseId,
    this.exercise,
  }) : super(key: key);
  
  // Constructor alternativo para compatibilidad con int
  factory ExerciseDetailScreen.fromIntId({
    Key? key,
    required int exerciseId,
    Exercise? exercise,
  }) {
    return ExerciseDetailScreen(
      key: key,
      exerciseId: exerciseId.toString(),
      exercise: exercise,
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Si ya tenemos el ejercicio, lo usamos directamente sin hacer petición
    if (exercise != null) {
      return _ExerciseDetailContent(
        exercise: exercise!,
        onRefresh: () async {},
      );
    }
    
    // Si no tenemos el ejercicio, usamos el provider
    final exerciseAsync = ref.watch(exerciseDetailProvider(exerciseId));
    
    return exerciseAsync.when(
      data: (exercise) {
        if (exercise == null) {
          return _ErrorView(
            message: 'No se encontró el ejercicio',
            onRetry: () => ref.refresh(exerciseDetailProvider(exerciseId)),
          );
        }
        return _ExerciseDetailContent(
          exercise: exercise,
          onRefresh: () => ref.refresh(exerciseDetailProvider(exerciseId)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _ErrorView(
        message: 'Error al cargar el ejercicio: $error',
        onRetry: () => ref.refresh(exerciseDetailProvider(exerciseId)),
      ),
    );
  }
}

class _ExerciseDetailContent extends ConsumerWidget {
  final Exercise exercise;
  final VoidCallback onRefresh;
  
  const _ExerciseDetailContent({
    required this.exercise,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
              exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Imagen del ejercicio
          _buildExerciseImage(),
          
          // Instrucciones del ejercicio
          _buildInstructionsCard(),
          
          // Información adicional del ejercicio
          _buildExerciseDetails(),
          
          // Botón para comenzar el ejercicio
          _buildStartExerciseButton(context),
        ],
      ),
    );
  }
  


  Widget _buildExerciseImage() {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty
          ? Image.network(
              exercise.imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => const _ErrorImagePlaceholder(),
            )
          : const _ErrorImagePlaceholder(),
    );
  }
  
  Widget _buildInstructionsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E4F0),
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
          const Text(
            'Instrucciones',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 8),
          if (exercise.instructions?.isNotEmpty ?? false)
            ...List.generate(
              exercise.instructions!.length,
              (index) => _buildInstructionItem(index),
            )
          else
            const Text(
              'No hay instrucciones disponibles para este ejercicio.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInstructionItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          Expanded(
            child: Text(
              exercise.instructions![index],
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExerciseDetails() {
    return Padding(
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
          _buildInfoRow('Tipo de ejercicio', exercise.type),
          _buildInfoRow('Músculo objetivo', exercise.targetMuscle),
          if (exercise.difficultyLevel != null)
            _buildInfoRow('Nivel de dificultad', exercise.difficultyLevel!),
          if (exercise.equipment?.isNotEmpty ?? false)
            _buildInfoRow('Equipamiento', exercise.equipment!.join(', ')),
          if (exercise.description?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            const Text(
              'Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(exercise.description!),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStartExerciseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _startExercise(context),
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
    );
  }
  
  void _startExercise(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseExecutionScreen(
          exerciseName: exercise.name,
          imageAsset: exercise.imageUrl ?? '',
          instructions: exercise.instructions ?? ['No hay instrucciones disponibles'],
          reps: 12, // Valor por defecto
          weight: '10kg', // Valor por defecto
          totalSets: 3, // Valor por defecto
        ),
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

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorImagePlaceholder extends StatelessWidget {
  const _ErrorImagePlaceholder();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Imagen no disponible',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}