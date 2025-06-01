import 'package:flutter/foundation.dart';
import 'package:fitpath/models/models.dart';
import 'package:fitpath/services/services.dart';

class WgerExercisesProvider with ChangeNotifier {
  final WgerService _wgerService;

  List<Exercise> _searchResults = [];
  Exercise? _selectedExercise;
  bool _isLoading = false;
  String? _error;

  WgerExercisesProvider(this._wgerService);

  List<Exercise> get searchResults => _searchResults;
  Exercise? get selectedExercise => _selectedExercise;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchExercises(String term, {int? limit}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _searchResults = await _wgerService.searchExercises(term, limit: limit);
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getExerciseDetails(int wgerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedExercise = await _wgerService.getExerciseDetails(wgerId);
    } catch (e) {
      _error = e.toString();
      _selectedExercise = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Exercise?> importExercise(int wgerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final importedExercise = await _wgerService.importExercise(wgerId);
      // Actualizar la lista de resultados si el ejercicio importado está en ella
      _searchResults = _searchResults.map((exercise) {
        if (exercise.id == importedExercise.id) {
          return importedExercise;
        }
        return exercise;
      }).toList();

      return importedExercise;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
