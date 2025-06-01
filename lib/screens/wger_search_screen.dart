import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitpath/models/models.dart';
import 'package:fitpath/providers/providers.dart';
import 'package:fitpath/screens/wger_exercise_details_screen.dart';

class WgerSearchScreen extends StatefulWidget {
  const WgerSearchScreen({Key? key}) : super(key: key);

  @override
  State<WgerSearchScreen> createState() => _WgerSearchScreenState();
}

class _WgerSearchScreenState extends State<WgerSearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final term = _searchController.text.trim();
    if (term.isNotEmpty) {
      context.read<WgerExercisesProvider>().searchExercises(term);
    }
  }

  Future<void> _handleImport(int wgerId) async {
    final provider = context.read<WgerExercisesProvider>();
    final exercise = await provider.importExercise(wgerId);

    if (exercise != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Ejercicio "${exercise.name}" importado con éxito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar ejercicios...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _handleSearch(),
                autofocus: true,
              )
            : const Text('Buscar Ejercicios WGER'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<WgerExercisesProvider>().clearSearchResults();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<WgerExercisesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.clearError(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.searchResults.isEmpty) {
            return const Center(
              child: Text('No hay resultados. Intenta buscar ejercicios.'),
            );
          }

          return ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final exercise = provider.searchResults[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: exercise.imageUrl != null
                      ? Image.network(
                          exercise.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fitness_center),
                        )
                      : const Icon(Icons.fitness_center),
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.type} • ${exercise.targetMuscle}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () =>
                        _handleImport(int.parse(exercise.id ?? '0')),
                    tooltip: 'Importar ejercicio',
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WgerExerciseDetailsScreen(
                          exercise: exercise,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
