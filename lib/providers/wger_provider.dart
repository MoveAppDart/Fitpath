import 'package:flutter/material.dart';
import '../services/wger_service.dart';

class WgerProvider extends ChangeNotifier {
  final WgerService _wgerService;
  bool _isLoading = false;
  String? _error;

  WgerProvider(this._wgerService);

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchExercises(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Implementar búsqueda de ejercicios
      await _wgerService.searchExercises(query);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
