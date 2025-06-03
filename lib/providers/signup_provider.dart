import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provider especializado que gestiona el estado del proceso de registro (onboarding)
/// Mantiene los datos del usuario entre los 6 pasos y facilita la validación
class SignupProvider with ChangeNotifier {
  // Datos de registro del usuario
  String? _gender;
  int? _age;
  double? _weightKg;
  int? _heightCm;
  String? _fitnessLevel;
  List<String>? _fitnessGoals;
  
  // Estado de navegación y UI
  int _currentStep = 1;
  bool _isLoading = false;
  String? _error;
  
  // Preferencias UI
  bool _useMetricSystem = true; // true = métrico (kg/cm), false = imperial (lb/in)
  
  // Getters para los datos
  String? get gender => _gender;
  int? get age => _age;
  double? get weightKg => _weightKg;
  double? get weightLbs => _weightKg != null ? _weightKg! * 2.20462 : null;
  int? get heightCm => _heightCm;
  int? get heightInches => _heightCm != null ? (_heightCm! * 0.393701).round() : null;
  String? get fitnessLevel => _fitnessLevel;
  List<String>? get fitnessGoals => _fitnessGoals;
  
  // Getters para el estado
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useMetricSystem => _useMetricSystem;
  
  // Métodos para actualizar datos
  
  /// Actualiza el género seleccionado
  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }
  
  /// Actualiza la edad seleccionada
  void setAge(int age) {
    _age = age;
    notifyListeners();
  }
  
  /// Actualiza el peso (siempre almacenado en kg internamente)
  void setWeight(double weight, {bool isMetric = true}) {
    if (isMetric) {
      _weightKg = weight;
    } else {
      // Convertir de libras a kg
      _weightKg = weight / 2.20462;
    }
    notifyListeners();
  }
  
  /// Actualiza la altura (siempre almacenada en cm internamente)
  void setHeight(int height, {bool isMetric = true}) {
    if (isMetric) {
      _heightCm = height;
    } else {
      // Convertir de pulgadas a cm
      _heightCm = (height * 2.54).round();
    }
    notifyListeners();
  }
  
  /// Establece el nivel de condición física
  void setFitnessLevel(String level) {
    _fitnessLevel = level;
    notifyListeners();
  }
  
  /// Establece los objetivos de fitness
  void setFitnessGoals(List<String> goals) {
    _fitnessGoals = goals;
    notifyListeners();
  }
  
  /// Cambia el sistema de medidas (métrico/imperial)
  void toggleMeasurementSystem() {
    _useMetricSystem = !_useMetricSystem;
    notifyListeners();
  }
  
  /// Avanza al siguiente paso si es válido
  bool goToNextStep() {
    if (canProceedToNextStep()) {
      _currentStep++;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  /// Retrocede al paso anterior
  void goToPreviousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }
  
  /// Establece el paso actual (para navegación directa)
  void setCurrentStep(int step) {
    if (step >= 1 && step <= 6) {
      _currentStep = step;
      notifyListeners();
    }
  }
  
  /// Resetea todos los datos del registro
  void resetSignupData() {
    _gender = null;
    _age = null;
    _weightKg = null;
    _heightCm = null;
    _fitnessLevel = null;
    _fitnessGoals = null;
    _currentStep = 1;
    _error = null;
    notifyListeners();
  }
  
  /// Determina si se puede avanzar al siguiente paso
  bool canProceedToNextStep() {
    switch (_currentStep) {
      case 1: // Género
        return _gender != null;
      case 2: // Edad
        return _age != null;
      case 3: // Peso
        return _weightKg != null;
      case 4: // Altura
        return _heightCm != null;
      case 5: // Nivel de condición física
        return _fitnessLevel != null;
      case 6: // Objetivos de fitness
        return _fitnessGoals != null && _fitnessGoals!.isNotEmpty;
      default:
        return false;
    }
  }
  
  /// Devuelve un mapa con todos los datos de registro para enviar al backend
  Map<String, dynamic> getSignupData() {
    return {
      'gender': _gender,
      'age': _age,
      'weight': _weightKg,
      'height': _heightCm,
      'fitnessLevel': _fitnessLevel,
      'fitnessGoals': _fitnessGoals,
      'preferredMeasurementSystem': _useMetricSystem ? 'metric' : 'imperial',
    };
  }
  
  /// Establece un mensaje de error
  void setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }
  
  /// Limpia cualquier mensaje de error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Establece el estado de carga
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
