import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../services/api/workout_service.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutService _workoutService;
  List<Workout> _workouts = [];
  Workout? _selectedWorkout;
  List<Exercise> _workoutExercises = [];
  Map<String, dynamic>? _workoutCalendar;
  List<dynamic> _routines = [];
  bool _isLoading = false;
  String? _error;
  
  WorkoutProvider(this._workoutService);
  
  List<Workout> get workouts => _workouts;
  Workout? get selectedWorkout => _selectedWorkout;
  List<Exercise> get workoutExercises => _workoutExercises;
  Map<String, dynamic>? get workoutCalendar => _workoutCalendar;
  List<dynamic> get routines => _routines;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Carga la lista de entrenamientos del usuario
  Future<bool> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.getWorkouts();
      
      if (response['success'] == true) {
        final workoutsData = response['data'] as List<dynamic>;
        _workouts = workoutsData.map((workoutJson) => Workout.fromJson(workoutJson)).toList();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al cargar entrenamientos';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Obtiene los detalles de un entrenamiento específico
  Future<bool> getWorkoutDetails(String workoutId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Obtener detalles del entrenamiento
      final workoutResponse = await _workoutService.getWorkout(workoutId);
      
      if (workoutResponse['success'] != true) {
        _error = workoutResponse['message'] ?? 'Error al obtener el entrenamiento';
        notifyListeners();
        return false;
      }
      
      _selectedWorkout = Workout.fromJson(workoutResponse['data']);
      
      // Obtener ejercicios del entrenamiento
      final exercisesResponse = await _workoutService.getExercisesForWorkout(workoutId);
      
      if (exercisesResponse['success'] == true) {
        final exercisesData = exercisesResponse['data'] as List<dynamic>;
        _workoutExercises = exercisesData.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = exercisesResponse['message'] ?? 'Error al obtener ejercicios';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Crea un nuevo entrenamiento
  Future<bool> createWorkout(Map<String, dynamic> workoutData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.createWorkout(workoutData);
      
      if (response['success'] == true) {
        // Recargar la lista de entrenamientos si la creación fue exitosa
        await loadWorkouts();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al crear el entrenamiento';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Actualiza un entrenamiento existente
  Future<bool> updateWorkout(String id, Map<String, dynamic> workoutData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.updateWorkout(id, workoutData);
      
      if (response['success'] == true) {
        // Actualizar el entrenamiento seleccionado si es el mismo que se está editando
        if (_selectedWorkout != null && _selectedWorkout!.id == id) {
          // Crear un nuevo objeto Workout con los datos actualizados
          _selectedWorkout = Workout.fromJson({
            ...response['data'],
            ...workoutData
          });
        }
        // Recargar la lista de entrenamientos
        await loadWorkouts();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al actualizar el entrenamiento';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Elimina un entrenamiento
  Future<bool> deleteWorkout(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.deleteWorkout(id);
      
      if (response['success'] == true) {
        // Limpiar el entrenamiento seleccionado si es el mismo que se está eliminando
        if (_selectedWorkout != null && _selectedWorkout!.id == id) {
          _selectedWorkout = null;
          _workoutExercises = [];
        }
        // Recargar la lista de entrenamientos
        await loadWorkouts();
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al eliminar el entrenamiento';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Registra un entrenamiento como completado
  Future<bool> logCompletedWorkout(String workoutId, Map<String, dynamic> completionData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.logCompletedWorkout(workoutId, completionData);
      
      if (response['success'] == true) {
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al registrar entrenamiento completado';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Obtiene el calendario de entrenamientos
  Future<bool> getWorkoutCalendar(String startDate, String endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.getWorkoutCalendar(startDate, endDate);
      
      if (response['success'] == true) {
        _workoutCalendar = response['data'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al obtener el calendario';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Obtiene las rutinas de entrenamiento
  Future<bool> getRoutines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _workoutService.getRoutines();
      
      if (response['success'] == true) {
        _routines = response['data'] as List<dynamic>;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Error al obtener rutinas';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
