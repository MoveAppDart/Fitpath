import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'workout_detail_screen.dart';
import 'create_plan_screen.dart';
import '../providers/workout_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/state_widgets.dart';
import '../widgets/workout_card.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);
      final success = await workoutProvider.loadWorkouts();

      if (!success && mounted) {
        setState(() {
          _error = workoutProvider.error ??
              'No se pudieron cargar los entrenamientos';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error al cargar entrenamientos: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider de entrenamientos para acceder a los datos
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // Colores predefinidos para las tarjetas de entrenamiento
    final List<Color> workoutColors = [
      const Color(0xFF4A90E2),
      const Color(0xFFE2844A),
      const Color(0xFF50E24A),
      const Color(0xFFE24A98),
      const Color(0xFF9E4AE2),
      const Color(0xFF4AE2C5),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF005DC8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? const LoadingState(message: 'Cargando entrenamientos...')
              : _error != null
                  ? ErrorState(
                      message: _error!,
                      onRetry: _loadWorkouts,
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con foto de perfil
                          Row(
                            children: [
                              userProvider.user?.profilePicture != null &&
                                      userProvider
                                          .user!.profilePicture!.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          userProvider.user!.profilePicture!),
                                    )
                                  : const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white24,
                                      child: Icon(
                                        Icons.person,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                              const SizedBox(width: 12),
                              Text(
                                'Hola, ${userProvider.user?.name.split(' ').first ?? 'Usuario'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Título de tus colecciones
                          const Text(
                            "Tus Entrenamientos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sección de rutinas - Usando datos reales del provider
                          workoutProvider.workouts.isEmpty
                              ? EmptyState(
                                  message:
                                      'No tienes entrenamientos todavía. ¡Crea tu primer entrenamiento!',
                                  icon: Icons.fitness_center,
                                  onAction: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreatePlanScreen(),
                                      ),
                                    );
                                  },
                                  actionLabel: 'Crear Entrenamiento',
                                )
                              : Column(
                                  children: [
                                    ...workoutProvider.workouts.map(
                                      (workout) => WorkoutListItem(
                                        title: workout.name,
                                        subtitle:
                                            '${workout.duration} min · ${workout.type}',
                                        isCompleted: workout.completed,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkoutDetailScreen(
                                                workoutId: workout.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    _buildNewRoutineButton(),
                                  ],
                                ),
                          const SizedBox(height: 40),

                          // Sección de programas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Programas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreatePlanScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Carrusel de programas - Usando datos reales o placeholders
                          workoutProvider.routines.isEmpty
                              ? const EmptyState(
                                  message:
                                      'No hay programas disponibles todavía',
                                  icon: Icons.calendar_today,
                                )
                              : SizedBox(
                                  height: 180,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: workoutProvider.routines.length,
                                    itemBuilder: (context, index) {
                                      final routine =
                                          workoutProvider.routines[index];
                                      return _buildProgramCard(
                                        title: routine['name'] ??
                                            'Programa ${index + 1}',
                                        duration: routine['duration'] ??
                                            '${index + 4} semanas',
                                        level: routine['level'] ??
                                            (index % 2 == 0
                                                ? 'Intermedio'
                                                : 'Avanzado'),
                                        color: workoutColors[
                                            index % workoutColors.length],
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildRoutineButton(String title, {required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewRoutineButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A4B94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New Routine',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String duration,
    required String level,
    Color? color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF1A4B94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              duration,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              level,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
