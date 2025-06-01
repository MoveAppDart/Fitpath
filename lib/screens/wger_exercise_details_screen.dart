import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitpath/models/models.dart';
import 'package:fitpath/providers/providers.dart';

class WgerExerciseDetailsScreen extends StatelessWidget {
  final Exercise exercise;

  const WgerExerciseDetailsScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final provider = context.read<WgerExercisesProvider>();
              final importedExercise = await provider.importExercise(
                int.parse(exercise.id ?? '0'),
              );

              if (importedExercise != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Ejercicio "${importedExercise.name}" importado con éxito',
                    ),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            tooltip: 'Importar ejercicio',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.imageUrl != null)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  exercise.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.fitness_center, size: 64)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de ejercicio',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(exercise.type),
                  const SizedBox(height: 16),
                  Text(
                    'Músculo objetivo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(exercise.targetMuscle),
                  if (exercise.difficultyLevel != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Nivel de dificultad',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(exercise.difficultyLevel!),
                  ],
                  if (exercise.equipment?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Equipamiento necesario',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ...exercise.equipment!.map((e) => Text('• $e')),
                  ],
                  if (exercise.description?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(exercise.description!),
                  ],
                  if (exercise.instructions?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Instrucciones',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ...exercise.instructions!.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('${entry.key + 1}. ${entry.value}'),
                          ),
                        ),
                  ],
                  if (exercise.videoUrl != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Video demostrativo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // TODO: Implementar reproductor de video
                    Text('Video disponible en: ${exercise.videoUrl}'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
